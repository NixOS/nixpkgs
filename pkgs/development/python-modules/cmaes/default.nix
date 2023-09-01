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
  disabled = pythonOlder "3.7";
  format = "pyproject";

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
    license = licenses.mit;
    maintainers = [ maintainers.bcdarwin ];
  };
}
