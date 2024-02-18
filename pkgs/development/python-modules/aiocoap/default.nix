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
