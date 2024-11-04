{
  lib,
  buildPythonPackage,
  cffi,
  construct,
  fetchPypi,
  hypothesis,
  pytest,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "brotlipy";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nt7wuFm+ryGRAVe0wz6zsG2M5FnJQhAvFpiMym6hZN8=";
  };

  build-system = [ setuptools ];

  propagatedNativeBuildInputs = [ cffi ];

  dependencies = [
    cffi
    construct
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  # Missing test files
  doCheck = false;

  pythonImportsCheck = [ "brotli" ];

  meta = {
    description = "Python bindings for the reference Brotli encoder/decoder";
    homepage = "https://github.com/python-hyper/brotlipy/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
