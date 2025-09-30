{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiosmtpd,
  django,

  # tests
  factory-boy,
  mock,
  pip,
  postgresql,
  pygments,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-django,
  shortuuid,
  vobject,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-extensions";
    repo = "django-extensions";
    tag = version;
    hash = "sha256-WgO/bDe4anQCc1q2Gdq3W70yDqDgmsvn39Qf9ZNVXuE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiosmtpd
    django
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    factory-boy
    mock
    pip
    postgresql
    pygments # not explicitly declared in setup.py, but some tests require it
    pytest-cov-stub
    pytest-django
    pytestCheckHook
    shortuuid
    vobject
    werkzeug
  ];

  disabledTestPaths = [
    # https://github.com/django-extensions/django-extensions/issues/1871
    "tests/test_dumpscript.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/django-extensions/django-extensions/releases/tag/${src.tag}";
    description = "Collection of custom extensions for the Django Framework";
    homepage = "https://github.com/django-extensions/django-extensions";
    license = licenses.mit;
  };
}
