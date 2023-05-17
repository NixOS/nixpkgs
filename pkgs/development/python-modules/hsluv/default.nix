{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hsluv";
  version = "5.0.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hsluv";
    repo = "hsluv-python";
    rev = "v${version}";
    hash = "sha256-p3KD+zhHCOs/rLUVf1IkW/isfpUPQstB2VHGmZ/aEPU=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hsluv" ];

  meta = with lib; {
    description = "Python implementation of HSLuv";
    homepage = "https://github.com/hsluv/hsluv-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
