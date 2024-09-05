{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  django,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
  pytz,
}:

buildPythonPackage rec {
  pname = "django-filter";
  version = "24.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "carltongibson";
    repo = "django-filter";
    rev = "refs/tags/${version}";
    hash = "sha256-4q/x9FO9ErKnGeJDEXDMcvUKA4nlA7nkwwM2xj3WGWs=";
  };

  build-system = [ flit-core ];

  dependencies = [ django ];

  pythonImportsCheck = [ "django_filters" ];

  nativeCheckInputs = [
    djangorestframework
    pytestCheckHook
    pytest-django
    pytz
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = with lib; {
    description = "Reusable Django application for allowing users to filter querysets dynamically";
    homepage = "https://github.com/carltongibson/django-filter";
    changelog = "https://github.com/carltongibson/django-filter/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
