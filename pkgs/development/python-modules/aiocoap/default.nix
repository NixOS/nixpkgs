{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pygments
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiocoap";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chrysn";
    repo = pname;
    rev = version;
    sha256 = "sha256-fTRDx9VEXDoMKM78YYL+mBEdvhbLtHiHdo66kwRnNhA=";
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

  pythonImportsCheck = [
    "aiocoap"
  ];

  meta = with lib; {
    description = "Python CoAP library";
    homepage = "https://aiocoap.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
