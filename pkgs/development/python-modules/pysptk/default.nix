{ stdenv
, lib
, buildPythonPackage, fetchPypi
, numpy, scipy, cython, six, decorator
}:

buildPythonPackage rec {
  pname = "pysptk";
  version = "0.1.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29e8e6a76243f3be728d23450982bd9f916530634079252a490ba7182bef30ca";
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
    broken = stdenv.isDarwin;
    description = "A python wrapper for Speech Signal Processing Toolkit (SPTK)";
    homepage = "https://pysptk.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
