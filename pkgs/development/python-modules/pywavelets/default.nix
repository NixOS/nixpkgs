{ lib
, buildPythonPackage
, fetchPypi
, cython
, nose
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "PyWavelets";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a64b40f6acb4ffbaccce0545d7fc641744f95351f62e4c6aaa40549326008c9";
  };

  checkInputs = [ nose pytest ];

  buildInputs = [ cython ];

  propagatedBuildInputs = [ numpy ];

  # Somehow nosetests doesn't run the tests, so let's use pytest instead
  checkPhase = ''
    py.test pywt/tests
  '';

  meta = {
    description = "Wavelet transform module";
    homepage = https://github.com/PyWavelets/pywt;
    license = lib.licenses.mit;
  };

}