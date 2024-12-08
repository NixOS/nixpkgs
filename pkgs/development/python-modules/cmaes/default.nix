{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  hypothesis,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cmaes";
  version = "0.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CyberAgentAILab";
    repo = "cmaes";
    rev = "refs/tags/v${version}";
    hash = "sha256-u2CgU9n8N9AMxfMBbDbnYzBMdl/IGOLTxOeh8RlnB/Y=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cmaes" ];

  disabledTests = [
    # Disable time-sensitive test
    "test_cma_tell"
  ];

  meta = with lib; {
    description = "Python library for CMA evolution strategy";
    homepage = "https://github.com/CyberAgentAILab/cmaes";
    changelog = "https://github.com/CyberAgentAILab/cmaes/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
