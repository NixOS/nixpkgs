{
  buildPythonPackage,
  fetchPypi,
  libmysqlclient,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mariadb";
  version = "1.1.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ozKJPj73zreXCrS9fIRLy0vWigUcpRMTVm+YCNdBHy0=";
  };

  # Should be in buildInputs, but was found by its executables
  nativeBuildInputs = [ libmysqlclient ];

  dependencies = [ setuptools ];

  # Requires a running MariaDB instance
  doCheck = false;

  pythonImportsCheck = [ "mariadb" ];

  meta = with lib; {
    description = "MariaDB Connector/Python";
    homepage = "https://github.com/mariadb-corporation/mariadb-connector-python";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
