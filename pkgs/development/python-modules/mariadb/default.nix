{ buildPythonPackage, fetchPypi, libmysqlclient, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "mariadb";
  version = "1.0.11";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dpFsiSvJNsWw824loUEfZRp7fOl4mSrjqN5+KD79rL8=";
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
