{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, cython
, nose
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "PyWavelets";
  version = "1.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6cbd69b047bb4e00873097472133425f5f08a4e6bc8b3f0ae709274d4d5e9a8d";
  };

  checkInputs = [ nose pytest ];

  buildInputs = [ cython ];

  propagatedBuildInputs = [ numpy ];

  # Somehow nosetests doesn't run the tests, so let's use pytest instead
  doCheck = false; # tests use relative paths, which fail to resolve
  checkPhase = ''
    py.test pywt/tests
  '';

  # ensure compiled modules are present
  pythonImportsCheck = [
    "pywt"
    "pywt._extensions._cwt"
    "pywt._extensions._dwt"
    "pywt._extensions._pywt"
    "pywt._extensions._swt"
  ];

  meta = with lib; {
    description = "Wavelet transform module";
    homepage = "https://github.com/PyWavelets/pywt";
    license = licenses.mit;
  };

}
