{ stdenv, buildPythonPackage, fetchPypi
, django, persisting-theory, six
}:

buildPythonPackage rec {
  pname = "django-dynamic-preferences";
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v7mf48gb2qmmks3ifnhkh0vfd7hpvx5v81ypc9cqy35n3ir0q4a";
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
