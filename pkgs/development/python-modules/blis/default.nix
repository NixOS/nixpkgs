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
  version = "0.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XUqB+UONt6GayOZK1BMx9lplnqjzuxiJqcIIjP2f4QQ=";
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
