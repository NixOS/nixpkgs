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
  version = "5.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sZw1/K6WiKwB73W61dsnMAwlN+tO4A7QfgXYRWoNSTE=";
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
