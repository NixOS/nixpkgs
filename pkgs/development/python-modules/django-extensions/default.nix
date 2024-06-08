{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  django,

  # tests
  factory-boy,
  mock,
  pip,
  pygments,
  pytestCheckHook,
  pytest-django,
  shortuuid,
  vobject,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "3.2.3";
  pyproject = true;

  # https://github.com/django-extensions/django-extensions/issues/1831
  # Requires asyncore, which was dropped in 3.12
  disabled = pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-A2+5FBv0IhTJPkwgd7je+B9Ac64UHJEa3HRBbWr2FxM=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=django_extensions --cov-report html --cov-report term" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ django ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    factory-boy
    mock
    pip
    pygments # not explicitly declared in setup.py, but some tests require it
    pytest-django
    pytestCheckHook
    shortuuid
    vobject
    werkzeug
  ];

  disabledTestPaths = [
    # requires network access
    "tests/management/commands/test_pipchecker.py"
    # django.db.utils.OperationalError: no such table: django_extensions_permmodel
    "tests/test_dumpscript.py"
  ];

  meta = with lib; {
    description = "A collection of custom extensions for the Django Framework";
    homepage = "https://github.com/django-extensions/django-extensions";
    license = licenses.mit;
  };
}
