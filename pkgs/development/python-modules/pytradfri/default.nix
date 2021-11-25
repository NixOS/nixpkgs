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
  version = "7.2.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    rev = version;
    sha256 = "sha256-/1K2jBgDuOIUb4WUownoceprZbOwSkQIqeEt07HfZrY=";
  };

  propagatedBuildInputs = [
    aiocoap
    dtlssocket
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytradfri" ];

  meta = with lib; {
    description = "Python package to communicate with the IKEA Trådfri ZigBee Gateway";
    homepage = "https://github.com/home-assistant-libs/pytradfri";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
