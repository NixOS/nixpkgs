{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  lib,
  pythonOlder,
  setuptools,
  tomli,
  twisted,
}:

let
  incremental = buildPythonPackage rec {
    pname = "incremental";
    version = "24.7.2";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "twisted";
      repo = "incremental";
      rev = "refs/tags/incremental-${version}";
      hash = "sha256-5MlIKUaBUwLTet23Rjd2Opf5e54LcHuZDowcGon0lOE=";
    };

    # From upstream's pyproject.toml:
    # "Keep this aligned with the project dependencies."
    build-system = dependencies;

    dependencies = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

    optional-dependencies = {
      scripts = [ click ];
    };

    # escape infinite recursion with twisted
    doCheck = false;

    nativeCheckInputs = [ twisted ];

    checkPhase = ''
      trial incremental
    '';

    passthru.tests = {
      check = incremental.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    pythonImportsCheck = [ "incremental" ];

    meta = {
      changelog = "https://github.com/twisted/incremental/blob/${src.rev}/NEWS.rst";
      homepage = "https://github.com/twisted/incremental";
      description = "Small library that versions your Python projects";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ dotlambda ];
    };
  };
in
incremental
