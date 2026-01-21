{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  packaging,
  pythonOlder,
  tomli,
  twisted,
}:

let
  incremental = buildPythonPackage rec {
    pname = "incremental";
    version = "24.11.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "twisted";
      repo = "incremental";
      tag = "incremental-${version}";
      hash = "sha256-GkTCQYGrgCUzizSgKhWeqJ25pfaYA7eUJIHt0q/iO0E=";
    };

    build-system = [ hatchling ];

    dependencies = [ packaging ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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
      changelog = "https://github.com/twisted/incremental/blob/${src.tag}/NEWS.rst";
      homepage = "https://github.com/twisted/incremental";
      description = "Small library that versions your Python projects";
      license = lib.licenses.mit;
      mainProgram = "incremental";
      maintainers = with lib.maintainers; [ dotlambda ];
    };
  };
in
incremental
