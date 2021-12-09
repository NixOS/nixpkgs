{ lib, buildPythonPackage, fetchFromGitHub
, django, persisting-theory, six
}:

buildPythonPackage rec {
  pname = "django-dynamic-preferences";
  version = "1.11.0";

  src = fetchFromGitHub {
     owner = "EliotBerriot";
     repo = "django-dynamic-preferences";
     rev = "1.11.0";
     sha256 = "0lyrc4pqrsybq6abc4dd3k0cfgaimsv5mldk7jgla1yxvlw7k9vf";
  };

  propagatedBuildInputs = [ six django persisting-theory ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DYNAMIC_PREFERENCES, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/EliotBerriot/django-dynamic-preferences";
    description = "Dynamic global and instance settings for your django project";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
