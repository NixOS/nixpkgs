{ stdenv, buildPythonPackage, fetchPypi, mysql }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "1.3.13";

  buildInputs = [
    mysql.connector-c
  ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff8ee1be84215e6c30a746b728c41eb0701a46ca76e343af445b35ce6250644f";
  };

  meta = with stdenv.lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
