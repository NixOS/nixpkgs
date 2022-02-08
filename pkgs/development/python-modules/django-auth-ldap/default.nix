{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, ldap
, django
, mock
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "3.0.0";
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "1f2d5c562d9ba9a5e9a64099ae9798e1a63840a11afe4d1c4a9c74121f066eaa";
  };

  nativeBuildInputs = [ setuptools-scm ];

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
