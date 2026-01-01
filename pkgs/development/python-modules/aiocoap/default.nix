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
<<<<<<< HEAD
=======
  pythonAtLeast,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  termcolor,
  websockets,
}:

buildPythonPackage rec {
  pname = "aiocoap";
<<<<<<< HEAD
  version = "0.4.17";
  pyproject = true;

=======
  version = "0.4.15";
  pyproject = true;

  disabled = pythonOlder "3.10";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "chrysn";
    repo = "aiocoap";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-l9MChfvBTJn/ABTqrw4i+YUNGJnDZmOJS/kumImaa/s=";
=======
    hash = "sha256-OYFHeTM1KXQfxeRoxYKdir3RnWJNua8YBmBUWIqADoI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    "test_blame"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "aiocoap" ];

<<<<<<< HEAD
  meta = {
    description = "Python CoAP library";
    homepage = "https://aiocoap.readthedocs.io/";
    changelog = "https://github.com/chrysn/aiocoap/blob/${src.tag}/NEWS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python CoAP library";
    homepage = "https://aiocoap.readthedocs.io/";
    changelog = "https://github.com/chrysn/aiocoap/blob/${version}/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
