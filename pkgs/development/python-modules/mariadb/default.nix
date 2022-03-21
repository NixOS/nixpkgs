{ buildPythonPackage, fetchPypi, libmysqlclient, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "mariadb";
  version = "1.0.10";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eQKLpgURc9rRrQvnUYOJyrcCOfkrT/i4gT2uVcPyxT0=";
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
