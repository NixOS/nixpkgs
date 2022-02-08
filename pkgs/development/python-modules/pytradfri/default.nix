{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiocoap
, dtlssocket
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytradfri";
  version = "9.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    rev = version;
    hash = "sha256-12ol+2CnoPfkxmDGJJAkoafHGpQuWC4lh0N7lSvx2DE=";
  };

  propagatedBuildInputs = [
    aiocoap
    dtlssocket
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytradfri"
  ];

  meta = with lib; {
    description = "Python package to communicate with the IKEA Trådfri ZigBee Gateway";
    homepage = "https://github.com/home-assistant-libs/pytradfri";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
