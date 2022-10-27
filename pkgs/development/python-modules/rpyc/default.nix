{ lib
, buildPythonPackage
, fetchFromGitHub
, plumbum
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = pname;
    rev = version;
    sha256 = "sha256-Xeot4QEgTZjvdO0ydmKjccp6zwC93Yp/HkRlSgyDf8k=";
  };

  propagatedBuildInputs = [
    plumbum
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests that requires network access
    "test_api"
    "test_pruning"
    "test_rpyc"
    # Test is outdated
    # ssl.SSLError: [SSL: NO_CIPHERS_AVAILABLE] no ciphers available (_ssl.c:997)
    "test_ssl_conenction"
  ];

  pythonImportsCheck = [
    "rpyc"
  ];

  meta = with lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = "https://rpyc.readthedocs.org";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
