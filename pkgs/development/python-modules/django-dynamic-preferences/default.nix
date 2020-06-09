{ stdenv, buildPythonPackage, fetchPypi
, django, persisting-theory, six
}:

buildPythonPackage rec {
  pname = "django-dynamic-preferences";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "727f71f865ff29df93c01a0a1686af0dca19776ee786f876ea0ae7e062719b24";
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
