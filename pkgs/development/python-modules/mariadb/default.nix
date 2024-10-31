{
  buildPythonPackage,
  fetchFromGitHub,
  libmysqlclient,
  lib,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mariadb";
  version = "1.1.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-YpA65J8ozKJfpOc4hZLdgCcT3j/lqRiNeX7k8U/aYkE=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    libmysqlclient # for mariadb_config
  ];

  buildInputs = [ libmysqlclient ];

  # Requires a running MariaDB instance
  doCheck = false;

  pythonImportsCheck = [ "mariadb" ];

  meta = {
    description = "MariaDB Connector/Python";
    homepage = "https://github.com/mariadb-corporation/mariadb-connector-python";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
