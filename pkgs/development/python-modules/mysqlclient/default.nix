{ stdenv, buildPythonPackage, fetchPypi, mysql }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "1.4.1";

  buildInputs = [
    mysql.connector-c
  ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "003ylvq50swf9kxrljj66jv1vffg7s617l2dz4pjvki61r0j08m6";
  };

  meta = with stdenv.lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
