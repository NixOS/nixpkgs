{
  lib,
  buildPythonPackage,
  fetchPypi,
  cffi,
  enum34,
  construct,
  pytest,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "brotlipy";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nt7wuFm+ryGRAVe0wz6zsG2M5FnJQhAvFpiMym6hZN8=";
  };

  propagatedBuildInputs = [
    cffi
    enum34
    construct
  ];

  propagatedNativeBuildInputs = [ cffi ];

  nativeCheckInputs = [
    pytest
    hypothesis
  ];

  checkPhase = ''
    py.test
  '';

  # Missing test files
  doCheck = false;

  meta = {
    description = "Python bindings for the reference Brotli encoder/decoder";
    homepage = "https://github.com/python-hyper/brotlipy/";
    license = lib.licenses.mit;
  };
}
