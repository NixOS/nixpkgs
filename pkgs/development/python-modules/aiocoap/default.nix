{
  lib,
  buildPythonPackage,
  cbor-diag,
  cbor2,
  cryptography,
  dtlssocket,
  fetchFromGitHub,
  filelock,
  ge25519,
  pygments,
  pytestCheckHook,
  setuptools,
  termcolor,
  websockets,
}:

buildPythonPackage rec {
  pname = "aiocoap";
  version = "0.4.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrysn";
    repo = "aiocoap";
    tag = version;
    hash = "sha256-l9MChfvBTJn/ABTqrw4i+YUNGJnDZmOJS/kumImaa/s=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    oscore = [
      cbor2
      cryptography
      filelock
      ge25519
    ];
    tinydtls = [ dtlssocket ];
    ws = [ websockets ];
    prettyprint = [
      termcolor
      cbor2
      pygments
      cbor-diag
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Don't test the plugins
    "tests/test_tls.py"
    "tests/test_reverseproxy.py"
    "tests/test_oscore_plugtest.py"
  ];

  disabledTests = [
    # Communication is not properly mocked
    "test_uri_parser"
    # Doctest
    "test_001"
    # CLI test
    "test_help"
    "test_blame"
  ];

  pythonImportsCheck = [ "aiocoap" ];

  meta = {
    description = "Python CoAP library";
    homepage = "https://aiocoap.readthedocs.io/";
    changelog = "https://github.com/chrysn/aiocoap/blob/${src.tag}/NEWS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
