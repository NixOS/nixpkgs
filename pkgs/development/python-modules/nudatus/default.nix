{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "nudatus";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ZanderBrown";
    repo = "nudatus";
    rev = version;
    sha256 = "sha256-yNFidirDkf624Zta8hcG/b/Q5RDzPtoCHEepSXdARXA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  pythonImportsCheck = [ "nudatus" ];

  meta = with lib; {
    description = "Strip comments from scripts, intended for use with MicroPython and other storage constrained environments";
    homepage = "https://github.com/zanderbrown/nudatus";
    license = licenses.mit;
    maintainers = with maintainers; [ rookeur ];
  };
}
