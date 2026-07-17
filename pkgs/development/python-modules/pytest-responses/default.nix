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
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "pytest-responses";
    tag = version;
    hash = "sha256-sn11MX5nab6dDhgZkV/cy4yGnOhB2MyrC+l/RGKEU/8=";
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
