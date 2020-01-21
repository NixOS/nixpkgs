{ lib
, buildPythonPackage
, fetchPypi
, check-manifest
, coverage
, codecov
, cython
, flake8
, lz4
, numpy
, pytest
, pytestcov
, python
, python-snappy
, twine
, wheel
}:

buildPythonPackage rec {
  pname = "fastavro";
  version = "0.22.9";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "fc3a97187d51aea9ad5ebb02bcb7a579a62da6310788ed82fb1e22abcd0ec33b";
  };
  
  nativeBuildInputs = [ cython ];
  
  propagatedBuildInputs = [ lz4 python-snappy ];
  
  preBuild = ''
    FASTAVRO_USE_CYTHON=1 ${python.interpreter} setup.py build_ext -i
  '';
  
  checkInputs = [
    check-manifest
    codecov
    coverage
    flake8
    numpy
    pytest
    pytestcov
    twine
    wheel
  ];
  
  # test_compression.py is missing zstandard package
  checkPhase = ''
    pytest tests --ignore=tests/test_compression.py
  '';
    
  meta = with lib; {
    description = "Fast read/write of AVRO files";
    homepage = "https://github.com/fastavro/fastavro";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
