{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "epicstore-api";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SD4RK";
    repo = "epicstore_api";
    rev = "refs/tags/v_${version}";
    hash = "sha256-AF2yNb06GShdaMS74pGFdHeM4U6ULdMCPzCyh8gSck0=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "epicstore_api" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # tests directory exists but contains no test cases
  doCheck = false;

  meta = {
    changelog = "https://github.com/SD4RK/epicstore_api/releases/tag/v_${version}";
    description = "Epic Games Store Web API Wrapper written in Python";
    homepage = "https://github.com/SD4RK/epicstore_api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
