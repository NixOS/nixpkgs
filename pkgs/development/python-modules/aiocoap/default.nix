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
  pythonAtLeast,
  pythonOlder,
  setuptools,
  termcolor,
  websockets,
}:

buildPythonPackage rec {
  pname = "aiocoap";
  version = "0.4.15";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "chrysn";
    repo = "aiocoap";
    tag = version;
    hash = "sha256-OYFHeTM1KXQfxeRoxYKdir3RnWJNua8YBmBUWIqADoI=";
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
  ];

  pythonImportsCheck = [ "aiocoap" ];

  meta = with lib; {
    description = "Python CoAP library";
    homepage = "https://aiocoap.readthedocs.io/";
    changelog = "https://github.com/chrysn/aiocoap/blob/${version}/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
