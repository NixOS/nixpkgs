{ lib
, buildPythonPackage, fetchPypi
, numpy, scipy, cython, six, decorator
}:

buildPythonPackage rec {
  pname = "pysptk";
  version = "0.1.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34c5ccc40c9e177cfd764daa9f7635c4c1e648e14ce78ba975537dae5a14c4e4";
  };

  PYSPTK_BUILD_VERSION = 0;

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    six
    decorator
  ];

  # No tests in the PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "A python wrapper for Speech Signal Processing Toolkit (SPTK)";
    homepage = "https://pysptk.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
