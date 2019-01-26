{ stdenv, buildPythonPackage, fetchPypi, mysql }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "1.3.14";

  buildInputs = [
    mysql.connector-c
  ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0symgjmzkckzsxx3piaxywls8q19s1pdgbmpm0v1m425wnfax09r";
  };

  meta = with stdenv.lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
