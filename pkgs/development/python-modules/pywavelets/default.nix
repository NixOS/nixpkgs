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
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c5cece36d4e17d395be6e9ac6b80ce7b774a1f71c251756c6163e63b6d878dc";
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