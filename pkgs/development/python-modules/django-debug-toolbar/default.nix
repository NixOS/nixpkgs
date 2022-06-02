{ lib
, fetchFromGitHub
, pythonOlder
, buildPythonPackage
, python
, django
, jinja2
, sqlparse
, html5lib
}:

buildPythonPackage rec {
  pname = "django-debug-toolbar";
  version = "3.2.4";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = version;
    sha256 = "1008yzxxs1cp1wc0xcc9xskc3f7naxc4srv1sikiank1bc3479ha";
  };

  propagatedBuildInputs = [
    django
    jinja2
    sqlparse
  ];

  DB_BACKEND = "sqlite3";
  DB_NAME = ":memory:";
  TEST_ARGS = "tests";
  DJANGO_SETTINGS_MODULE = "tests.settings";

  checkInputs = [
    html5lib
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test ${TEST_ARGS}
    runHook postCheck
  '';

  meta = {
    description = "Configurable set of panels that display debug information about the current request/response";
    homepage = "https://github.com/jazzband/django-debug-toolbar";
    changelog = "https://django-debug-toolbar.readthedocs.io/en/latest/changes.html";
    maintainers =  with lib.maintainers; [ yuu ];
    license = lib.licenses.bsd3;
  };
}
