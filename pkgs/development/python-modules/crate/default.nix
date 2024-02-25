{ lib
, fetchPypi
, buildPythonPackage
, dask
, urllib3
, geojson
, pandas
, pythonOlder
, sqlalchemy
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "crate";
  version = "0.34.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nEWrfCd2MQCcIM6dLkVYc/cWT5wcT/pvYaY2V3wfuto=";
  };

  propagatedBuildInputs = [
    urllib3
    sqlalchemy
    geojson
  ];

  nativeCheckInputs = [
    dask
    pandas
    pytestCheckHook
    pytz
  ];

  disabledTests = [
    # the following tests require network access
    "test_layer_from_uri"
    "test_additional_settings"
    "test_basic"
    "test_cluster"
    "test_default_settings"
    "test_dynamic_http_port"
    "test_environment_variables"
    "test_verbosity"
  ] ++ (lib.optionals (lib.versionOlder version "0.35.3") [
    # the following tests require older Pandas, in a future version they will not
    # https://github.com/crate/crate-python/commit/db7ba4d0e1f4f4087739a8f9ebe1d71946333979
    "test_bulk_save_dask"
    "test_bulk_save_pandas"
  ]);

  disabledTestPaths = [
    # imports setuptools.ssl_support, which doesn't exist anymore
    "src/crate/client/test_http.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/crate/crate-python";
    description = "A Python client library for CrateDB";
    changelog = "https://github.com/crate/crate-python/blob/${version}/CHANGES.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
