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
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-debug-toolbar";
  version = "5.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-debug-toolbar";
    tag = version;
    hash = "sha256-Q0joSIFXhoVmNQ+AfESdEWUGY1xmJzr4iR6Ak54YM7c=";
  };

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
    maintainers = with maintainers; [ yuu ];
  };
}
