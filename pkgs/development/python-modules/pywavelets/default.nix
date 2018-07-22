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
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce36e2f0648ea1781490b09515363f1f64446b0eac524603e5db5e180113bed9";
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