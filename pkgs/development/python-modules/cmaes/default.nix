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
<<<<<<< HEAD
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "0.9.1";
  disabled = pythonOlder "3.7";
  format = "pyproject";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "CyberAgentAILab";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-1mXulG/yqNwKQKDFGBh8uxIYOPSsm8+PNp++CSswc50=";
=======
    hash = "sha256-dd5vLT4Q0cI5ts0WgBpjPtOA81exGNjWSNHEiPggYbg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook hypothesis ];

  pythonImportsCheck = [ "cmaes" ];

  meta = with lib; {
    description = "Python library for CMA evolution strategy";
    homepage = "https://github.com/CyberAgentAILab/cmaes";
<<<<<<< HEAD
    changelog = "https://github.com/CyberAgentAILab/cmaes/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = [ maintainers.bcdarwin ];
  };
}
