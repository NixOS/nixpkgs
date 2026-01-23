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
    version = "0.0.20";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "fastapi";
      repo = "fastapi-cli";
      tag = version;
      hash = "sha256-RTxu6WmKmGMVsQ2izd8j8P+gGbXV91gVjb95JC52e8Q=";
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

    meta = {
      description = "Run and manage FastAPI apps from the command line with FastAPI CLI";
      homepage = "https://github.com/fastapi/fastapi-cli";
      changelog = "https://github.com/fastapi/fastapi-cli/releases/tag/${src.tag}";
      mainProgram = "fastapi";
      license = lib.licenses.mit;
      maintainers = [ ];
      # This package provides a `fastapi`-executable that is in conflict with the one from
      # python3Packages.fastapi. Because this package is primarily used for the purpose of
      # implementing the CLI for python3Packages.fastapi, we reduce the executable's priority
      priority = 10;
    };
  };
in
self
