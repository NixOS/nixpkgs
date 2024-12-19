{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  typer,
  fastapi,
  uvicorn,

  # checks
  pytestCheckHook,
  rich,
}:

let
  self = buildPythonPackage rec {
    pname = "fastapi-cli";
    version = "0.0.5";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "tiangolo";
      repo = "fastapi-cli";
      rev = "refs/tags/${version}";
      hash = "sha256-hUS9zkDJJB51X+e31RvyxcGAP8j4oulAPFAvEMPiIn8=";
    };

    build-system = [ pdm-backend ];

    dependencies = [
      typer
      uvicorn
    ] ++ uvicorn.optional-dependencies.standard;

    optional-dependencies = {
      standard = [
        uvicorn
      ] ++ uvicorn.optional-dependencies.standard;
    };

    doCheck = false;

    passthru.tests.pytest = self.overridePythonAttrs { doCheck = true; };

    nativeCheckInputs = [
      pytestCheckHook
      rich
    ] ++ optional-dependencies.standard;

    # coverage
    disabledTests = [ "test_script" ];

    pythonImportsCheck = [ "fastapi_cli" ];

    meta = with lib; {
      description = "Run and manage FastAPI apps from the command line with FastAPI CLI";
      homepage = "https://github.com/tiangolo/fastapi-cli";
      changelog = "https://github.com/tiangolo/fastapi-cli/releases/tag/${version}";
      mainProgram = "fastapi";
      license = licenses.mit;
      maintainers = [ ];
      # This package provides a `fastapi`-executable that is in conflict with the one from
      # python3Packages.fastapi. Because this package is primarily used for the purpose of
      # implementing the CLI for python3Packages.fastapi, we reduce the executable's priority
      priority = 10;
    };
  };
in
self
