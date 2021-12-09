{ lib
, buildPythonPackage
, fetchFromGitHub, isPy27
, ldap , django
, mock
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "3.0.0";
  disabled = isPy27;
  src = fetchFromGitHub {
     owner = "django-auth-ldap";
     repo = "django-auth-ldap";
     rev = "3.0.0";
     sha256 = "0v1fb9mrhfvpi570rb2id9q9zz1p72psvrzkih7fp756z2hy8xhj";
  };

  propagatedBuildInputs = [ ldap django ];
  checkInputs = [ mock ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting INSTALLED_APPS, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  pythonImportsCheck = [ "django_auth_ldap" ];

  meta = with lib; {
    description = "Django authentication backend that authenticates against an LDAP service";
    homepage = "https://github.com/django-auth-ldap/django-auth-ldap";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
    platforms = platforms.linux;
  };
}
