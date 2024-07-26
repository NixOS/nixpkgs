{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  responses,
}:

buildPythonPackage rec {
  pname = "pytest-responses";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "pytest-responses";
    rev = "refs/tags/${version}";
    hash = "sha256-6QAiNWCJbo4rmaByrc8VNw39/eF3uqFOss3GJuCvpZg=";
  };

  build-system = [ setuptools ];

  dependencies = [ responses ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_responses" ];

  meta = {
    description = "Plugin for py.test response";
    homepage = "https://github.com/getsentry/pytest-responses";
    changelog = "https://github.com/getsentry/pytest-responses/blob/${version}/CHANGES";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "pytest-reponses";
  };
}
