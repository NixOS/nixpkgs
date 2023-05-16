{ lib
, fetchFromGitHub
, pythonOlder
, buildPythonPackage
, python
, hatchling
, django
, jinja2
, sqlparse
, html5lib
}:

buildPythonPackage rec {
  pname = "django-debug-toolbar";
<<<<<<< HEAD
  version = "4.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "3.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-hPO2q3V69kpyahav4cgUHz/3WLxXnZYCyWGetyNS+2Q=";
=======
    hash = "sha256-GlEw25wem8iwwm3rYLk6TFEAIzC1pYjpSHdAkHwtFcE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    django
    jinja2
    sqlparse
  ];

  DB_BACKEND = "sqlite3";
  DB_NAME = ":memory:";
  TEST_ARGS = "tests";
  DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    html5lib
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test ${TEST_ARGS}
    runHook postCheck
  '';

  pythonImportsCheck = [
    "debug_toolbar"
  ];

  meta = with lib; {
    description = "Configurable set of panels that display debug information about the current request/response";
    homepage = "https://github.com/jazzband/django-debug-toolbar";
    changelog = "https://django-debug-toolbar.readthedocs.io/en/latest/changes.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yuu ];
<<<<<<< HEAD
  };
=======
};
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
