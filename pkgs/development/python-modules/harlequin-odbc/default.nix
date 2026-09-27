{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  hatchling,
  duckdb,
  pyodbc,
}:
buildPythonPackage rec {
  pname = "harlequin-odbc";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "harlequin_odbc";
    inherit version;
    hash = "sha256-mDVsXrqswj2v814WXUSQ4eoQ3FkfqcsIJPQScrOdE/A=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pyodbc
  ]
  ++ lib.optional (pythonAtLeast "3.14") duckdb;

  doCheck = false;
  pythonRemoveDeps = [
    "harlequin"
  ];

  meta = {
    description = "A Harlequin adapter for ODBC drivers.";
    homepage = "https://pypi.org/project/harlequin-odbc/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c4patino ];
  };
}
