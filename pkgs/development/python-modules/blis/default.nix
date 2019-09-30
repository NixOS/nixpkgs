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
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1khh02z6wryrnrxlx2wrxzhaqsg5hlgypy0643rvi4zcqanvdpym";
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
