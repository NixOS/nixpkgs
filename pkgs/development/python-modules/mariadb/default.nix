{
  buildPythonPackage,
  fetchFromGitHub,
  libmysqlclient,
  packaging,
  lib,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mariadb";
  version = "1.1.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-python";
    tag = "v${version}";
    hash = "sha256-BYE+W/P2/kPtbi6tzE1FQkI/KFCO5C1KQnB67XfJqkA=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    libmysqlclient # for mariadb_config
  ];

  buildInputs = [ libmysqlclient ];

  dependencies = [
    packaging # do not rely on pythonImportsCheck when removing, it pulls in build-system dependencies
  ];

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
