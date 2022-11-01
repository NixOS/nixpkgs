{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, plumbum
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "5.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = pname;
    rev = version;
    hash = "sha256-SDt6Oh+8qRIdM02FEFM+Xw1y/bBn66D6KbOrhGVs6ng=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    plumbum
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests that requires network access
    "test_api"
    "test_close_timeout"
    "test_deploy"
    "test_listing"
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
