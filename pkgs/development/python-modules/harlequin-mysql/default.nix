{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  python3Packages,
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

  dependencies = with python3Packages; [
    mysql-connector
  ];

  pythonRelaxDeps = [
    "mysql-connector-python"
  ];

  # To prevent circular dependency
  # as harlequin-mysql requires harlequin which requires harlequin-mysql
  doCheck = false;
  pythonRemoveDeps = [
    "harlequin"
  ];

  meta = {
    description = "A Harlequin adapter for MySQL";
    homepage = "https://pypi.org/project/harlequin-mysql/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
