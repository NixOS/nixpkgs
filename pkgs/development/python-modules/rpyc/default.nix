{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, hatchling
, plumbum
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "5.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2b6ryqDqZPs5VniLhCwA1/c9+3CT+JJrr3VwP3G6tpY=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    plumbum
  ];

  nativeCheckInputs = [
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

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = "https://rpyc.readthedocs.org";
    changelog = "https://github.com/tomerfiliba-org/rpyc/blob/${version}/CHANGELOG.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
