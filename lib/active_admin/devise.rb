require 'devise'

module ActiveAdmin
  module Devise

    def self.config
      config = {
        :path => ActiveAdmin.application.default_namespace,
        :controllers => ActiveAdmin::Devise.controllers,
        :path_names => { :sign_in => 'login', :sign_out => "logout" }
      }

      if ::Devise.respond_to?(:sign_out_via)
        logout_methods = [::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].flatten.uniq
        config.merge!( :sign_out_via => logout_methods)
      end

      config
    end

    def self.controllers
      {
        :sessions => "active_admin/devise/sessions",
        :passwords => "active_admin/devise/passwords",
        :unlocks => "active_admin/devise/unlocks"
      }
    end

    module Controller
      extend ::ActiveSupport::Concern
      included do
        layout 'active_admin_logged_out'
        helper ::ActiveAdmin::ViewHelpers
      end

      # Redirect to the default namespace on logout
      # see https://github.com/gregbell/active_admin/issues/1791
      def root_path
        root_path_method = [ActiveAdmin.application.default_namespace, :root_path].join('_')
        respond_to?(root_path_method) ? send(root_path_method) : '/'
      end
    end

    class SessionsController < ::Devise::SessionsController
      include ::ActiveAdmin::Devise::Controller
    end

    class PasswordsController < ::Devise::PasswordsController
      include ::ActiveAdmin::Devise::Controller
    end

    class UnlocksController < ::Devise::UnlocksController
      include ::ActiveAdmin::Devise::Controller
    end

  end
end
