{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder

# build-system
, setuptools

# optionals
, cbor2
, cbor-diag
, cryptography
, filelock
, ge25519
, dtlssocket
, websockets
, termcolor
, pygments

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiocoap";
  version = "0.4.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chrysn";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-4iwoPfmIwk+PlWUp60aqA5qZgzyj34pnZHf9uH5UhnY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru.optional-dependencies = {
    oscore = [
      cbor2
      cryptography
      filelock
      ge25519
    ];
    tinydtls = [
      dtlssocket
    ];
    ws = [
      websockets
    ];
    prettyprint = [
      termcolor
      cbor2
      pygments
      cbor-diag
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/chrysn/aiocoap/issues/339
    "--deselect=tests/test_server.py::TestServerTCP::test_big_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_empty_accept"
    "--deselect=tests/test_server.py::TestServerTCP::test_error_resources"
    "--deselect=tests/test_server.py::TestServerTCP::test_fast_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_js_accept"
    "--deselect=tests/test_server.py::TestServerTCP::test_manualbig_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_nonexisting_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_replacing_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_root_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_slow_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_slowbig_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_spurious_resource"
    "--deselect=tests/test_server.py::TestServerTCP::test_unacceptable_accept"
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
