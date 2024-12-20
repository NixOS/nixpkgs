{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  aiosmtpd,
  django,
  looseversion,

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

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-A2+5FBv0IhTJPkwgd7je+B9Ac64UHJEa3HRBbWr2FxM=";
  };

  patches = [
    (fetchpatch2 {
      # Replace dead asyncore, smtp implementation with aiosmtpd
      name = "django-extensions-aiosmtpd.patch";
      url = "https://github.com/django-extensions/django-extensions/commit/37d56c4a4704c823ac6a4ef7c3de4c0232ceee64.patch";
      hash = "sha256-49UeJQKO0epwY/7tqoiHgOXdgPcB/JBIZaCn3ulaHTg=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=django_extensions --cov-report html --cov-report term" ""

    substituteInPlace django_extensions/management/commands/pipchecker.py \
      --replace-fail "from distutils.version" "from looseversion"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiosmtpd
    django
    looseversion
  ];

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

  disabledTests = [
    # Mismatch in expectation of exception message
    "test_installed_apps_no_resolve_conflicts_function"
  ];

  disabledTestPaths = [
    # requires network access
    "tests/management/commands/test_pipchecker.py"
    # django.db.utils.OperationalError: no such table: django_extensions_permmodel
    "tests/test_dumpscript.py"
  ];

  meta = with lib; {
    description = "Collection of custom extensions for the Django Framework";
    homepage = "https://github.com/django-extensions/django-extensions";
    license = licenses.mit;
  };
}
