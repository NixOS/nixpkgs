{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
  withCExtensions ? true,
}:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P22EP0200OxQHEZFPCKk++uxq/tbdA4byrNMYVzXQGs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
  ];

  env = lib.optionalAttrs (!withCExtensions) {
    CBOR2_BUILD_C_EXTENSION = "0";
  };

  passthru = {
    inherit withCExtensions;
  };

  pythonImportsCheck = [ "cbor2" ];

  meta = {
    description = "Python CBOR (de)serializer with extensive tag support";
    changelog = "https://github.com/agronholm/cbor2/releases/tag/${version}";
    homepage = "https://github.com/agronholm/cbor2";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "cbor2";

  };
}
