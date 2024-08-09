{ lib
, buildPythonPackage
, fetchFromGitHub
, pdm-backend
, typer
, fastapi
, uvicorn

# checks
, pytestCheckHook
, rich
}:

let self = buildPythonPackage rec {
  pname = "fastapi-cli";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi-cli";
    rev = version;
    hash = "sha256-eWvZn7ZeLnQZAvGOzY77o6oO5y+QV2cx+peBov9YpJE=";
  };

  build-system = [ pdm-backend ];

  dependencies = [ typer ];

  optional-dependencies = {
    standard = [
      fastapi
      uvicorn
    ];
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
  };
};
in self
