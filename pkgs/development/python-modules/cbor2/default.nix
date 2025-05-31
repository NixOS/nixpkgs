{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  withCExtensions ? true,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  hypothesis,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.6.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-toKCBnfuHbukX32hGJjScg+S4Gvjas7CkIZ9Xr89fgk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "cbor2" ];

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

  meta = with lib; {
    changelog = "https://github.com/agronholm/cbor2/releases/tag/${version}";
    description = "Python CBOR (de)serializer with extensive tag support";
    mainProgram = "cbor2";
    homepage = "https://github.com/agronholm/cbor2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
