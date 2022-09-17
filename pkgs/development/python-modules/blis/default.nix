{ lib
, buildPythonPackage
, fetchPypi
, cython
, hypothesis
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "blis";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aZ4coUlnFjcLS5tSfFjYQr+JKGPY2UTNoy+HIO08tCk=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];


  checkInputs = [
    hypothesis
    pytest
  ];

  meta = with lib; {
    description = "BLAS-like linear algebra library";
    homepage = "https://github.com/explosion/cython-blis";
    license = licenses.bsd3;
    platforms = platforms.x86_64;
  };
}
