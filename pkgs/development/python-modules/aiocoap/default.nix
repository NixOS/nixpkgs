{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pygments
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiocoap";
  version = "0.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chrysn";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-t2yfWWfkJmOr14XdLsIV48HMgVRaEnUO4IG2jQHbKWA=";
  };

  propagatedBuildInputs = [
    pygments
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/chrysn/aiocoap/blob/${version}/NEWS";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
