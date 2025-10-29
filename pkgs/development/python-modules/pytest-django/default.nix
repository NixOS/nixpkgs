{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
  setuptools-scm,
  django-configurations,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-django";
  version = "4.11.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_django";
    inherit version;
    hash = "sha256-qUkUGh7hA8sOeiDxRR01X4P15KXQe91Nz90f0P8ieZE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [ django ];

  nativeCheckInputs = [
    django-configurations
    # pytest-xidst causes random errors in the form of: django.db.utils.OperationalError: no such table: app_item
    pytestCheckHook
  ];

  preCheck = ''
    # bring pytest_django_test module into PYTHONPATH
    export PYTHONPATH="$PWD:$PYTHONPATH"

    # test the lightweight sqlite flavor
    export DJANGO_SETTINGS_MODULE="pytest_django_test.settings_sqlite"
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/pytest-dev/pytest-django/blob/v${version}/docs/changelog.rst";
    description = "Pytest plugin for testing of Django applications";
    homepage = "https://pytest-django.readthedocs.org/en/latest/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
