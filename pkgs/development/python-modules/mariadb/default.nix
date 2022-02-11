{ buildPythonPackage, fetchPypi, libmysqlclient, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "mariadb";
  version = "1.0.9";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Aqmz0KB26aDQ6hxItF7Qm2R14rak6Mge2fHoLK87/Ck=";
    extension = "zip";
  };

  nativeBuildInputs = [
    libmysqlclient
  ];

  # Requires a running MariaDB instance
  doCheck = false;

  pythonImportsCheck = [ "mariadb" ];

  meta = with lib; {
    description = "MariaDB Connector/Python";
    homepage = "https://github.com/mariadb-corporation/mariadb-connector-python";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ vanilla ];
  };
}
