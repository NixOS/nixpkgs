{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, cython
, hypothesis
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "blis";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c5hd0bim9134sk8wb31cqzvi9c380rbl5zwjiwrq8nnix8a2k1d";
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
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
