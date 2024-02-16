{ buildPythonPackage, fetchPypi, libmysqlclient, wheel, setuptools, packaging, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "mariadb";
  version = "1.1.10";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ozKJPj73zreXCrS9fIRLy0vWigUcpRMTVm+YCNdBHy0=";
  };

  nativeBuildInputs = [
    libmysqlclient
    setuptools
    wheel
    packaging
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
