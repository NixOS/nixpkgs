{ lib
, buildPythonPackage
, fetchPypi, isPy27
, ldap , django
, mock
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "2.3.0";
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "5894317122a086c9955ed366562869a81459cf6b663636b152857bb5d3a0a3b7";
  };

  propagatedBuildInputs = [ ldap django ];
  checkInputs = [ mock ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting INSTALLED_APPS, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  meta = with lib; {
    description = "Django authentication backend that authenticates against an LDAP service";
    homepage = "https://github.com/django-auth-ldap/django-auth-ldap";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
    platforms = platforms.linux;
  };
}
