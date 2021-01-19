{ lib, stdenv, buildPythonPackage, fetchPypi, odpic }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "8.1.0";

  buildInputs = [ odpic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1698c5522ee1355e552b30bfa0a58e6e772475b882c5d69d158bd7e6aed45de";
  };

  preConfigure = ''
    export ODPIC_INC_DIR="${odpic}/include"
    export ODPIC_LIB_DIR="${odpic}/lib"
  '';

  # Check need an Oracle database to run
  doCheck = false;

  meta = with lib; {
    description = "Python interface to Oracle";
    homepage = "https://oracle.github.io/python-cx_Oracle";
    license = licenses.bsd3;
    maintainers = with maintainers; [ y0no ];
  };
}
