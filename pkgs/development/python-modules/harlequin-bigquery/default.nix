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
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "harlequin_bigquery";
    inherit version;
    hash = "sha256-jdDwmfiU7x4zl4hg12evrPqLEzPB2M8/1HN4d0N1EJQ=";
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
    description = "Harlequin adapter for Google BigQuery";
    homepage = "https://pypi.org/project/harlequin-bigquery/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
