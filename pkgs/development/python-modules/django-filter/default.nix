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
  version = "26.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "carltongibson";
    repo = "django-filter";
    tag = version;
    hash = "sha256-Sls/imzl2dzUfVcJTUqpCQTDRH9H09uxx27TnU0R0WI=";
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

  meta = {
    description = "Reusable Django application for allowing users to filter querysets dynamically";
    homepage = "https://github.com/carltongibson/django-filter";
    changelog = "https://github.com/carltongibson/django-filter/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
