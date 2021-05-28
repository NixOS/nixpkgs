{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, hypothesis
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "blis";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "014771a0f753a64ef5610c5b3d4a090b263073bdd59b8ad0d872ce1e06e7315a";
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

  meta = with stdenv.lib; {
    description = "BLAS-like linear algebra library";
    homepage = "https://github.com/explosion/cython-blis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danieldk ];
  };
}
