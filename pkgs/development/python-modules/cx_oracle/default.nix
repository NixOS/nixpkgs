{ stdenv, buildPythonPackage, fetchPypi, odpic }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "6.4.1";

  buildInputs = [ odpic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "3519bf3263c9892aaadc844735aca02d3773ed9b92f97e069cd1726882a7d1b6";
  };

  preConfigure = ''
    export ODPIC_INC_DIR="${odpic}/include"
    export ODPIC_LIB_DIR="${odpic}/lib"
  '';

  # Check need an Oracle database to run
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python interface to Oracle";
    homepage = "https://oracle.github.io/python-cx_Oracle";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ y0no ];
  };
}
