{
  lib,
  fetchFromGitHub,
  pythonOlder,
  buildPythonPackage,

  # build-system
  hatchling,

  # dependencies
  django,
  sqlparse,

  # tests
  django-csp,
  html5lib,
  jinja2,
  pygments,
}:

buildPythonPackage rec {
  pname = "django-debug-toolbar";
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-debug-toolbar";
    tag = version;
    hash = "sha256-ZNevSqEpTdk0cZeMzOpbtatEiV9SAsVUlRb9YddcAGY=";
  };

  postPatch = ''
    # not actually used and we don't have django-template-partials packaged
    sed -i "/template_partials/d" tests/settings.py
  '';

  build-system = [ hatchling ];

  dependencies = [
    django
    sqlparse
  ];

  env = {
    DB_BACKEND = "sqlite3";
    DB_NAME = ":memory:";
    DJANGO_SETTINGS_MODULE = "tests.settings";
  };

  nativeCheckInputs = [
    django-csp
    html5lib
    jinja2
    pygments
  ];

  checkPhase = ''
    runHook preCheck
    python -m django test tests
    runHook postCheck
  '';

  pythonImportsCheck = [ "debug_toolbar" ];

  meta = with lib; {
    description = "Configurable set of panels that display debug information about the current request/response";
    homepage = "https://github.com/jazzband/django-debug-toolbar";
    changelog = "https://django-debug-toolbar.readthedocs.io/en/latest/changes.html";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
