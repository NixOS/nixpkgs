{
  lib,
  fetchFromGitHub,
  pythonOlder,
  buildPythonPackage,
  python,
  hatchling,
  django,
  jinja2,
  sqlparse,
  html5lib,
}:

buildPythonPackage rec {
  pname = "django-debug-toolbar";
  version = "4.4.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-eLC3GnhYuEunKkKXNMtaFCqjyf8rn5cTkjL7Ep4Qp3c=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    django
    jinja2
    sqlparse
  ];

  DB_BACKEND = "sqlite3";
  DB_NAME = ":memory:";
  TEST_ARGS = "tests";
  DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [ html5lib ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test ${TEST_ARGS}
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
