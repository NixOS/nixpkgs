{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pygments
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiocoap";
  version = "0.4.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chrysn";
    repo = pname;
    rev = version;
    sha256 = "0k7ii2l3n139f8712ja6w3z73xiwlfsjgdc4k5c514ni2w6w2yjc";
  };

  propagatedBuildInputs = [
    pygments
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Don't test the plugins
    "tests/test_tls.py"
    "tests/test_reverseproxy.py"
    "tests/test_oscore_plugtest.py"
  ];

  disabledTests = [
    # Communication is not properly mocked
    "test_uri_parser"
  ];

  pythonImportsCheck = [ "aiocoap" ];

  meta = with lib; {
    description = "Python CoAP library";
    homepage = "https://aiocoap.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
