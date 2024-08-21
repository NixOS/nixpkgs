{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
  setuptools-scm,
  django-configurations,
  pytest,
  pytest-xdist,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "pytest-django";
  version = "4.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XQVP4BHFbzsQ+Xj0Go77Llrfx+aA7zb7VxraHyR3nZA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [ django ];

  nativeCheckInputs = [
    django-configurations
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    # bring pytest_django_test module into PYTHONPATH
    export PYTHONPATH="$(pwd):$PYTHONPATH"

    # test the lightweight sqlite flavor
    export DJANGO_SETTINGS_MODULE="pytest_django_test.settings_sqlite"
  '';

  disabledTests = [
    # AttributeError: type object 'TestLiveServer' has no attribute '_test_settings_before_run'
    "test_settings_restored"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/pytest-dev/pytest-django/blob/v${version}/docs/changelog.rst";
    description = "Pytest plugin for testing of Django applications";
    homepage = "https://pytest-django.readthedocs.org/en/latest/";
    license = licenses.bsd3;
  };
}
