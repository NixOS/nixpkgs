{ stdenv, buildPythonPackage, fetchPypi, oracle-instantclient }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "6.1";

  buildInputs = [
    oracle-instantclient
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "80545fc7acbdda917dd2b1604c938141256bdfed3ad464a44586c9c2f09c3004";
  };

  # Check need an Oracle database to run  
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python interface to Oracle";
    homepage = "https://oracle.github.io/python-cx_Oracle";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ y0no ];
  };
}
