{ stdenv, buildPythonPackage, fetchPypi, oracle-instantclient }:

buildPythonPackage rec {
  pname = "cx_Oracle";
  version = "6.2.1";

  buildInputs = [
    oracle-instantclient
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "01970bc843b3c699a7fd98af19e0401fe69abfbd2acdf464e0bf2ae06ea372b9";
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
