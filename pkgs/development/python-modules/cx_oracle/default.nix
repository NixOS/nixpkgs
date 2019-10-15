{ stdenv, buildPythonPackage, fetchPypi, odpic }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "7.2.3";

  buildInputs = [ odpic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b1zarb6g1b2nl3bj9m5ph1sxqc44bscwq30300q78hm666sbf6z";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ y0no ];
  };
}
