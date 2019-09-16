{ lib
, buildPythonPackage, fetchPypi
, numpy, scipy, cython, six, decorator
}:

buildPythonPackage rec {
  pname = "pysptk";
  version = "0.1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa8bd2ae84bfe72e9015ccb69eb3b687bc64fad6139ae0b327fe07918e1e28ff";
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
    homepage = https://pysptk.readthedocs.io/en/latest/;
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
