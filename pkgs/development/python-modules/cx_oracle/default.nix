{ stdenv, buildPythonPackage, fetchPypi, odpic }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "7.3.0";

  buildInputs = [ odpic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e0da54e948b55e5c75fab14b391d58aa8b9be1eddfd9ec9a8a0e500bc8bfc7e";
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
