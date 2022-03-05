{ lib, buildPythonPackage, fetchPypi, libmysqlclient }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.1.0";

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
    sha256 = "973235686f1b720536d417bf0a0d39b4ab3d5086b2b6ad5e6752393428c02b12";
  };

  meta = with lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl1;
    maintainers = with maintainers; [ y0no ];
  };
}
