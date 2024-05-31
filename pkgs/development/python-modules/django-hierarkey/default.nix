{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # propagates
  python-dateutil,

  # tests
  django-extensions,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-hierarkey";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-hierarkey";
    rev = "refs/tags/${version}";
    hash = "sha256-1LSH9GwoNF3NrDVNUIHDAVsktyKIprDgB5XlIHeM3fM=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  pythonImportsCheck = [ "hierarkey" ];

  nativeCheckInputs = [
    django-extensions
    pytest-django
    pytestCheckHook
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  pytestFlagsArray = [ "tests" ];

  meta = with lib; {
    description = "Flexible and powerful hierarchical key-value store for your Django models";
    homepage = "https://github.com/raphaelm/django-hierarkey";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
