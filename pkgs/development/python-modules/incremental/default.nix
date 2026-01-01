{
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  hatchling,
  lib,
  packaging,
  pythonOlder,
=======
  click,
  fetchFromGitHub,
  lib,
  pythonOlder,
  setuptools,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  tomli,
  twisted,
}:

let
  incremental = buildPythonPackage rec {
    pname = "incremental";
<<<<<<< HEAD
    version = "24.11.0";
=======
    version = "24.7.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pyproject = true;

    src = fetchFromGitHub {
      owner = "twisted";
      repo = "incremental";
      tag = "incremental-${version}";
<<<<<<< HEAD
      hash = "sha256-GkTCQYGrgCUzizSgKhWeqJ25pfaYA7eUJIHt0q/iO0E=";
    };

    build-system = [ hatchling ];

    dependencies = [ packaging ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];
=======
      hash = "sha256-5MlIKUaBUwLTet23Rjd2Opf5e54LcHuZDowcGon0lOE=";
    };

    # From upstream's pyproject.toml:
    # "Keep this aligned with the project dependencies."
    build-system = dependencies;

    dependencies = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

    optional-dependencies = {
      scripts = [ click ];
    };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
      changelog = "https://github.com/twisted/incremental/blob/${src.tag}/NEWS.rst";
      homepage = "https://github.com/twisted/incremental";
      description = "Small library that versions your Python projects";
      license = lib.licenses.mit;
      mainProgram = "incremental";
=======
      changelog = "https://github.com/twisted/incremental/blob/${src.rev}/NEWS.rst";
      homepage = "https://github.com/twisted/incremental";
      description = "Small library that versions your Python projects";
      license = lib.licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      maintainers = with lib.maintainers; [ dotlambda ];
    };
  };
in
incremental
