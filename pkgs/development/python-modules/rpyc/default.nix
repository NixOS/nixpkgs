{ lib
, buildPythonPackage
, fetchFromGitHub
, plumbum
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = pname;
    rev = version;
    sha256 = "1g75k4valfjgab00xri4pf8c8bb2zxkhgkpyy44fjk7s5j66daa1";
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
