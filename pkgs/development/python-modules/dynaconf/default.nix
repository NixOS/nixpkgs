{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ansible-core,
  boto3,
  commentjson,
  configobj,
  django,
  django-debug-toolbar,
  flask,
  hvac,
  ipython,
  pytest-cov-stub,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  python-dotenv,
  radon,
  toml,
  tox,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "dynaconf";
  version = "3.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dynaconf";
    repo = "dynaconf";
    tag = version;
    hash = "sha256-9E9us6niUtPJkZ89uKXz6wByoEERwxS/xW5qvkIXIhQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ ansible-core ];

  nativeCheckInputs = [
    boto3
    commentjson
    configobj
    django
    django-debug-toolbar
    flask
    hvac
    ipython
    pytest-cov-stub
    pytest-mock
    pytest-xdist
    pytestCheckHook
    python-dotenv
    radon
    toml
    tox
    versionCheckHook
  ];

  disabledTests = [
    # AssertionError: assert 42.1 == 'From development env'
    "test_envless_load_file"
  ];

  disabledTestPaths = [
    # import file mismatch
    # imported module 'app_test' has this __file__ attribute:
    # /build/source/tests_functional/issues/1005-key-type-error/app_test.py
    # which is not the same as the test file we want to collect:
    # /build/source/tests_functional/issues/994_validate_on_update_fix/app_test.py
    "tests_functional/django_pytest_pure/app/tests"
    "tests_functional/issues/575_603_666_690__envvar_with_template_substitution/app_test.py"
    "tests_functional/issues/658_nested_envvar_override/app_test.py"
    "tests_functional/issues/835_926_enable-merge-equal-false/app_test.py"
    "tests_functional/issues/994_validate_on_update_fix/app_test.py"
    "tests_functional/pytest_example/app/tests"
    "tests_functional/pytest_example/flask/tests"
    # flask.cli.NoAppException: Failed to find Flask application or factory in module 'app'
    # Use 'app:name' to specify one
    "tests/test_cli.py"
    # sqlite3.OperationalError: no such table: auth_user
    "tests_functional/django_pytest/app/tests/test_app.py::test_admin_user"
    # unable connect port
    "tests/test_redis.py"
    # need docker
    "tests/test_vault.py"
  ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting LOGGING_CONFIG
  # but settings are not configured
  env.DJANGO_SETTINGS_MODULE = "project.settings";

  pythonImportsCheck = [ "dynaconf" ];

  versionCheckProgramArg = "--version";

  meta = {
    description = "Dynamic configurator for Python Project";
    homepage = "https://github.com/dynaconf/dynaconf";
    changelog = "https://github.com/dynaconf/dynaconf/blob/${src.tag}/CHANGELOG.md";
    mainProgram = "dynaconf";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
