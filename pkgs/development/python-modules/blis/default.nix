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
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d69257d317e86f34a7f230a2fd1f021fd2a1b944137f40d8cdbb23bd334cd0c4";
  };

  nativeBuildInputs = [
    cython
  ];


  checkInputs = [
    cython
    hypothesis
    numpy
    pytest
  ];

  meta = with stdenv.lib; {
    description = "BLAS-like linear algebra library";
    homepage = https://github.com/explosion/cython-blis;
    license = licenses.bsd3;
    maintainers = with maintainers; [ danieldk ];
  };
}
