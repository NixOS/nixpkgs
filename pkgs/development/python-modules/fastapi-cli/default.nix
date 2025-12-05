{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  rich-toolkit,
  typer,
  uvicorn,

  # checks
  pytestCheckHook,
  rich,
}:

let
  self = buildPythonPackage rec {
    pname = "fastapi-cli";
    version = "0.0.8";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "tiangolo";
      repo = "fastapi-cli";
      tag = version;
      hash = "sha256-7SYsIgRSFZgtIHBC5Ic9Nlh+LtGJDz0Xx1yxMarAuYY=";
    };

    build-system = [ pdm-backend ];

    dependencies = [
      rich-toolkit
      typer
      uvicorn
    ]
    ++ uvicorn.optional-dependencies.standard;

    optional-dependencies = {
      standard = [
        uvicorn
      ]
      ++ uvicorn.optional-dependencies.standard;
    };

    doCheck = false;

    passthru.tests.pytest = self.overridePythonAttrs { doCheck = true; };

    nativeCheckInputs = [
      pytestCheckHook
      rich
    ]
    ++ optional-dependencies.standard;

    # coverage
    disabledTests = [ "test_script" ];

    pythonImportsCheck = [ "fastapi_cli" ];

    meta = with lib; {
      description = "Run and manage FastAPI apps from the command line with FastAPI CLI";
      homepage = "https://github.com/tiangolo/fastapi-cli";
      changelog = "https://github.com/tiangolo/fastapi-cli/releases/tag/${src.tag}";
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
