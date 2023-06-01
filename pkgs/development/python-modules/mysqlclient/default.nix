{ lib, buildPythonPackage, fetchPypi, libmysqlclient }:

buildPythonPackage rec {
  pname = "mysqlclient";
  version = "2.1.1";

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
    hash = "sha256-godX5Bn7Ed1sXtJXbsksPvqpOg98OeJjWG0e53nD14I=";
  };

  meta = with lib; {
    description = "Python interface to MySQL";
    homepage = "https://github.com/PyMySQL/mysqlclient-python";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ y0no ];
  };
}
