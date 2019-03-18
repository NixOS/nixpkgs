{ stdenv, buildPythonPackage, fetchPypi, mysql }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "1.4.2.post1";

  nativeBuildInputs = [
    mysql.connector-c
  ];

  buildInputs = [
    mysql.connector-c
  ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f257d250f2675d0ef99bd318906f3cfc05cef4a2f385ea695ff32a3f04b9f9a7";
  };

  meta = with stdenv.lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
