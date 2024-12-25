{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  google-cloud-bigquery,
  google-cloud-bigquery-storage,
}:

buildPythonPackage rec {
  pname = "harlequin-bigquery";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "harlequin_bigquery";
    inherit version;
    hash = "sha256-uIPYhK4R6N7pqsKY2GozkG76WI+gru2unsK5BxO4+/Y=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    google-cloud-bigquery
    google-cloud-bigquery-storage
  ];

  # To prevent circular dependency
  # as harlequin-bigquery requires harlequin which requires harlequin-bigquery
  doCheck = false;
  pythonRemoveDeps = [
    "harlequin"
  ];

  meta = {
    description = "A Harlequin adapter for Google BigQuery";
    homepage = "https://pypi.org/project/harlequin-bigquery/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
