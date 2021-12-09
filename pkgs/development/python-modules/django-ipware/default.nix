{ lib, buildPythonPackage, fetchFromGitHub, django }:

buildPythonPackage rec {
  pname = "django-ipware";
  version = "4.0.0";

  src = fetchFromGitHub {
     owner = "un33k";
     repo = "django-ipware";
     rev = "v4.0.0";
     sha256 = "1sr2vbnpiq6hqqs4xdfhsylvjcq9ygpjafc25gzvhwlq5zrh8vbq";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting IPWARE_TRUSTED_PROXY_LIST, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;

  # pythonImportsCheck fails with:
  # django.core.exceptions.ImproperlyConfigured: Requested setting IPWARE_META_PRECEDENCE_ORDER, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.

  meta = with lib; {
    description = "A Django application to retrieve user's IP address";
    homepage = "https://github.com/un33k/django-ipware";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
