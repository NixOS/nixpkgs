{ lib
, buildPythonPackage
, coapthon3
, fetchFromGitHub
, pycryptodomex
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "py-air-control";
  version = "2.2.0";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "rgerganov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-woDLol1JbBE3I17p/mXlMOvLhuqJinEpZEvaPu3T/sc=";
  };

  propagatedBuildInputs = [
    coapthon3
    pycryptodomex
  ];

  checkInputs = [
    requests
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests have issues in the sandbox
    "testing/test_http.py"
  ];

  pythonImportsCheck = [ "pyairctrl" ];

  meta = with lib; {
    description = "Command line tool for controlling Philips air purifiers";
    homepage = "https://github.com/rgerganov/py-air-control";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
