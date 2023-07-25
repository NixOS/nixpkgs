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
  version = "0.9.1";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "CyberAgentAILab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dd5vLT4Q0cI5ts0WgBpjPtOA81exGNjWSNHEiPggYbg=";
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
