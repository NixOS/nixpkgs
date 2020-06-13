{ stdenv
, buildPythonPackage
, fetchPypi, isPy27
, ldap , django 
, mock
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "2.2.0";
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "11af1773b08613339d2c3a0cec1308a4d563518f17b1719c3759994d0b4d04bf";
  };

  propagatedBuildInputs = [ ldap django ]; 
  checkInputs = [ mock ]; 

  # django.core.exceptions.ImproperlyConfigured: Requested setting INSTALLED_APPS, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Django authentication backend that authenticates against an LDAP service";
    homepage = "https://github.com/django-auth-ldap/django-auth-ldap";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
    platforms = platforms.linux;
  };
}
