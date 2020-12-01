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
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19557b14763253ca3d4f6cfc9c9fe2eed3d65db14fa273ced8b0c17ce2bfda4a";
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
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ danieldk ];
  };
}
