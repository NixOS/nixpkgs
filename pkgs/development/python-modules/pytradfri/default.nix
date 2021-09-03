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
  version = "7.0.6";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    rev = version;
    sha256 = "0ckh2waz3xpz51pmigg1q336igqvvkl2pzncszvblkwv38a0rj3a";
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
