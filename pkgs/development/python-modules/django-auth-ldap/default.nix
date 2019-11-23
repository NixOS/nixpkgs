{ stdenv
, buildPythonPackage
, fetchPypi, isPy27
, ldap , django_2_2 
, mock
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "2.0.0";
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "1samrxf8lic6a4c0lgw31b38s97l8hnaknd7ilyy2plahmm0h03i";
  };

  propagatedBuildInputs = [ ldap django_2_2 ]; 
  checkInputs = [ mock ]; 

  # django.core.exceptions.ImproperlyConfigured: Requested setting INSTALLED_APPS, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Django authentication backend that authenticates against an LDAP service";
    homepage = https://github.com/django-auth-ldap/django-auth-ldap;
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
    platforms = platforms.linux;
  };
}
