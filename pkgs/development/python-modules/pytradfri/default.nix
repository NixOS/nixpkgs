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
  version = "8.0.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    rev = version;
    hash = "sha256-Wxz2P55lc7yJ1OXNXYWb25a+xtMs1sANNc7hE7nawHI=";
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
