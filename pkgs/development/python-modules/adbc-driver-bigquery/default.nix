{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  adbc-driver-manager,
  importlib-resources,
  arrow-adbc,
}:

buildPythonPackage (finalAttrs: {
  pname = "adbc-driver-bigquery";
  version = "1.11.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "adbc_driver_bigquery";
    inherit (finalAttrs) version;
    hash = "sha256-N/wqkN/sH3Qbx0db31DHRMItBewTXQhYk0EXkSwGB34=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    adbc-driver-manager
    importlib-resources
  ];

  # Tests don't work - they require an unknown pytest fixture `bigquery_auth_type`
  doCheck = false;

  env.ADBC_BIGQUERY_LIBRARY = "libadbc_driver_bigquery${stdenv.hostPlatform.extensions.sharedLibrary}";
  preBuild = ''
    cp ${lib.getLib arrow-adbc}/lib/$ADBC_BIGQUERY_LIBRARY .
    chmod u+w $ADBC_BIGQUERY_LIBRARY
  '';

  pythonImportsCheck = [
    "adbc_driver_bigquery"
  ];

  meta = {
    description = "ADBC driver for working with BigQuery";
    homepage = "https://pypi.org/project/adbc-driver-bigquery";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
