{ lib
, buildPythonPackage
, fetchPypi
, cffi
, enum34
, construct
, pytest
, hypothesis
}:

buildPythonPackage rec {
  pname = "brotlipy";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36def0b859beaf21910157b4c33eb3b06d8ce459c942102f16988cca6ea164df";
  };

  propagatedBuildInputs = [ cffi enum34 construct ];

  propagatedNativeBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytest hypothesis ];

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
