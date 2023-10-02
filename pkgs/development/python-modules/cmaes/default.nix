{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, hypothesis
, numpy
, setuptools
}:

buildPythonPackage rec {
  pname = "cmaes";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CyberAgentAILab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1mXulG/yqNwKQKDFGBh8uxIYOPSsm8+PNp++CSswc50=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook hypothesis ];

  pythonImportsCheck = [ "cmaes" ];

  meta = with lib; {
    description = "Python library for CMA evolution strategy";
    homepage = "https://github.com/CyberAgentAILab/cmaes";
    changelog = "https://github.com/CyberAgentAILab/cmaes/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.bcdarwin ];
  };
}
