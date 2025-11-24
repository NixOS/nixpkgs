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
  version = "25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "carltongibson";
    repo = "django-filter";
    tag = version;
    hash = "sha256-ODbBlaJo6sgXkFxLNhqwGTXSHs2d6R6wGKyDz5qA7bs=";
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
