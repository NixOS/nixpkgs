{ stdenv
, lib
, buildPythonPackage, fetchPypi
, numpy, scipy, cython, six, decorator
}:

buildPythonPackage rec {
  pname = "pysptk";
  version = "0.1.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AZUDI9AL57tXz7VzPGF9uEeKW4/6JsaBUiFkigl640Q=";
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
