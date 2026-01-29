{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  pytest-django,
  pytest-cov,
  pytest-randomly,
  pytest-mock,
  pytestCheckHook,
  poetry-core,
  typing-extensions,
  django-stubs,
  mypy,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-test-migrations";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "django-test-migrations";
    tag = version;
    hash = "sha256-mYDGGfkLo+GMgItCje46KtXdPsedawRKXLbRnD+CC+8=";
  };

  disabled = pythonOlder "3.10";

  dependencies = [
    django
    typing-extensions
  ];

  build-system = [ poetry-core ];
  doCheck = true;
  preCheck = ''
    export DJANGO_SETTINGS_MODULE=django_test_app.settings
    export DJANGO_DATABASE_NAME=db.sqlite3
    export PYTHONPATH=$PYTHONPATH:$src/django_test_app
  '';
  pythonImportsCheck = [ "django_test_migrations" ];

  disabledTests = [
    # Don't know why these tests won't work
    "test_call_pytest_setup_plan"
    "test_pytest_markers"
  ];
  pytestFlags = [ "--cov-fail-under=90" ];

  nativeCheckInputs = [
    mypy
    django-stubs
    pytest-django
    pytestCheckHook
    pytest-cov
    pytest-randomly
    pytest-mock
  ];

  meta = with lib; {
    description = "Test django schema and data migrations, including migrations' order and best practices.";
    homepage = "https://github.com/wemake-services/django-test-migrations";
    changelog = "https://github.com/wemake-services/django-test-migrations/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
