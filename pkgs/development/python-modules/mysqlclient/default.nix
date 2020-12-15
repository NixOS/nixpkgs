{ stdenv, buildPythonPackage, fetchPypi, libmysqlclient }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.0.2";

  nativeBuildInputs = [
    libmysqlclient
  ];

  buildInputs = [
    libmysqlclient
  ];

  # Tests need a MySQL database
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8df057b08fc27d8f7106bfa997d0a21e2acef017f905f06d6fb0aa6a20d4d2b2";
  };

  meta = with stdenv.lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
