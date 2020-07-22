{ stdenv, buildPythonPackage, fetchPypi
, django, persisting-theory, six
}:

buildPythonPackage rec {
  pname = "django-dynamic-preferences";
  version = "1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "407db27bf55d391c4c8a4944e0521f35eff82c2f2fd5a2fc843fb1b4cc1a31f4";
  };

  propagatedBuildInputs = [ six django persisting-theory ]; 

  # django.core.exceptions.ImproperlyConfigured: Requested setting DYNAMIC_PREFERENCES, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/EliotBerriot/django-dynamic-preferences";
    description = "Dynamic global and instance settings for your django project";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
