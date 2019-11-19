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
  version = "1.1.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a64b40f6acb4ffbaccce0545d7fc641744f95351f62e4c6aaa40549326008c9";
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
    homepage = https://github.com/PyWavelets/pywt;
    license = licenses.mit;
  };

}
