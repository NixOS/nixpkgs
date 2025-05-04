{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  mysql-connector,
}:

buildPythonPackage rec {
  pname = "harlequin-mysql";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "harlequin_mysql";
    inherit version;
    hash = "sha256-Ru9CxbZYVo9TQO5TwkHLEzPz4EkUgHwfg3Qeg1F4eLM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    mysql-connector
  ];

  # To prevent circular dependency
  # as harlequin-postgres requires harlequin which requires harlequin-postgres
  doCheck = false;
  pythonRemoveDeps = [
    "harlequin"
  ];

  meta = {
    description = "Harlequin adapter for MySQL";
    homepage = "https://pypi.org/project/harlequin-mysql/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ knvpk ];
  };
}
