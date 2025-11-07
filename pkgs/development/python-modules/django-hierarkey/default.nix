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
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-hierarkey";
    tag = version;
    hash = "sha256-zIz7aokOGLGXV/xJnYcz8lBP7b2rxLrfaD3i/DLpFR8=";
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

  enabledTestPaths = [ "tests" ];

  meta = with lib; {
    description = "Flexible and powerful hierarchical key-value store for your Django models";
    homepage = "https://github.com/raphaelm/django-hierarkey";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
