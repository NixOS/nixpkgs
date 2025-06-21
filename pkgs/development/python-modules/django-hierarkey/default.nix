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
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-hierarkey";
    tag = version;
    hash = "sha256-GkCNVovo2bDCp6m2GBvusXsaBhcmJkPNu97OdtsYROY=";
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
