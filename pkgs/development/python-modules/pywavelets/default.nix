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
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a12c7a6258c0015d2c75d88b87393ee015494551f049009e8b63eafed2d78efc";
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