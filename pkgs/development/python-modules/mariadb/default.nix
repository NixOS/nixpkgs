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
  version = "1.1.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-python";
    tag = "v${version}";
    hash = "sha256-f3WeVtsjxm/HVPv0cbpPkmklcNFWJaFqI2LxDElcCFw=";
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
