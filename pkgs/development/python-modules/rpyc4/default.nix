{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
, hatchling
, plumbum
, pytestCheckHook
, pythonOlder
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "rpyc4";
  # Pinned version for linien, see also:
  # https://github.com/linien-org/pyrp3/pull/10#discussion_r1302816237
  version = "4.1.5";
  format = "pyproject";

  # Since this is an outdated version, upstream might have fixed the
  # compatibility issues with Python3.12, but we can't enjoy them yet.
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "rpyc";
    rev = version;
    hash = "sha256-8NOcXZDR3w0TNj1+LZ7lzQAt7yDgspjOp2zk1bsbVls=";
  };

  nativeBuildInputs = [
    setuptools
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
  disabledTestPaths = [
    "tests/test_ssh.py"
    "tests/test_teleportation.py"
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
