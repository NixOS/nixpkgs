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
  version = "3.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dynaconf";
    repo = "dynaconf";
    tag = version;
    hash = "sha256-Tdz6LDDoXf6SUYZP63yanMc5uLQYa8pnZruZx9hs3fc=";
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
    # These tests share global state and fail when pytest-xdist runs the
    # suite in parallel.
    "test_extracted_validators_from_annotated"
    "test_validator_from_types"
    "test_default_value_from_types"
  ];

  disabledTestPaths = [
    # Under the full suite (pytest-xdist) the flask CLI raises NoAppException
    # for 'dynaconf write', and a few subprocess tests fail.
    "tests/test_cli.py"
    # All these files are named app_test.py; pytest imports the one under
    # 1005-key-type-error first, then rejects the others with
    # ImportPathMismatchError.
    "tests_functional/issues/575_603_666_690__envvar_with_template_substitution/app_test.py"
    "tests_functional/issues/658_nested_envvar_override/app_test.py"
    "tests_functional/issues/835_926_enable-merge-equal-false/app_test.py"
    "tests_functional/issues/994_validate_on_update_fix/app_test.py"
    # Its conftest.py shares the module name app.tests.conftest with
    # tests_functional/legacy/django_pytest/app/tests/conftest.py, so pytest
    # rejects it with ImportPathMismatchError.
    "tests_functional/legacy/django_pytest_pure/app/tests"
    # Needs pytest-django to create the auth_user table; without it the test
    # fails with sqlite3.OperationalError: no such table: auth_user.
    "tests_functional/legacy/django_pytest/app/tests/test_app.py::test_admin_user"
    # Integration tests that need a running redis container.
    "tests/test_redis.py"
    # Integration tests that need a running vault container.
    "tests/test_vault.py"
    # ImportError while importing the test module.
    "tests/test_release_utility.py"
    # Their conftest.py is also named tests.conftest, which clashes with
    # tests/conftest.py.
    "tests_functional/legacy/pytest_example_app/flask/tests"
    "tests_functional/legacy/pytest_example_app/tests"
  ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting LOGGING_CONFIG
  # but settings are not configured
  env.DJANGO_SETTINGS_MODULE = "project.settings";

  pythonImportsCheck = [ "dynaconf" ];

  meta = {
    description = "Dynamic configurator for Python Project";
    homepage = "https://github.com/dynaconf/dynaconf";
    changelog = "https://github.com/dynaconf/dynaconf/blob/${src.tag}/CHANGELOG.md";
    mainProgram = "dynaconf";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
