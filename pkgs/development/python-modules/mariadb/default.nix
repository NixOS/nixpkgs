{ lib
, buildPythonPackage
, fetchFromGitHub
, libmysqlclient
, pythonOlder
, packaging
, setuptools
}:

buildPythonPackage rec {
  pname = "mariadb";
  version = "1.1.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-python";
    rev = "v${version}";
    hash = "sha256-OBtGIet7e0So5eaQFT2Q1GSfUzQVkcGxVE5ghCDqri8=";
  };

  nativeBuildInputs = [
    libmysqlclient
    setuptools
  ];

  propagatedBuildInputs = [
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
