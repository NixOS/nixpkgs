{ stdenv, buildPythonPackage, fetchPypi
, django, persisting-theory, six
}:

buildPythonPackage rec {
  pname = "django-dynamic-preferences";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z2dndkpypk4pvb0byh5a771vgp50vn8g1rbk5r3sml6dm4wcn7s";
  };

  propagatedBuildInputs = [ six django persisting-theory ]; 

  # django.core.exceptions.ImproperlyConfigured: Requested setting DYNAMIC_PREFERENCES, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/EliotBerriot/django-dynamic-preferences;
    description = "Dynamic global and instance settings for your django project";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
