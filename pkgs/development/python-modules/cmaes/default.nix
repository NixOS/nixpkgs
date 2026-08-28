{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  hypothesis,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cmaes";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CyberAgentAILab";
    repo = "cmaes";
    tag = "v${version}";
    hash = "sha256-GzBAymSb6frMXvHtd1Xl5gK62pYuXKd3XU9TLhe+sJ4=";
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

  meta = {
    description = "Python library for CMA evolution strategy";
    homepage = "https://github.com/CyberAgentAILab/cmaes";
    changelog = "https://github.com/CyberAgentAILab/cmaes/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
