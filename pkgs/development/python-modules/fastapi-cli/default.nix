{ lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  coverage,
  pdm-backend,
  rich,
  typer,
  fastapi,
  uvicorn,
}:

let self = buildPythonPackage {
  pname = "fastapi-cli";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi-cli";
    rev = "refs/tags/${self.version}";
    hash = "sha256-eWvZn7ZeLnQZAvGOzY77o6oO5y+QV2cx+peBov9YpJE=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    rich
    typer
  ];

  passthru.optional-dependencies = {
    standard = [
      fastapi
      uvicorn
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    coverage
  ] ++ self.passthru.optional-dependencies.standard;
  doCheck = false;

  # Enable tests via passthru to avoid cyclic dependency with `fastapi`:
  passthru.tests.${self.pname} = self.overridePythonAttrs { doCheck = true; };

  pythonImportsCheck = [ "fastapi_cli" ];

  meta = with lib; {
    description = "Run and manage FastAPI apps from the command line with FastAPI CLI";
    homepage = "https://github.com/tiangolo/fastapi-cli";
    changelog = "https://github.com/tiangolo/fastapi-cli/releases/tag/${self.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}; in
self
