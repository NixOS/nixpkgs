{ lib
, fetchPypi
, buildPythonPackage
, urllib3
, geojson
, pythonOlder
, sqlalchemy
, pytestCheckHook
, pytz
, stdenv
}:

buildPythonPackage rec {
  pname = "crate";
  version = "0.31.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SYjzyPqKR6BpC5z3P/ASDXe0mwi8Hz413b8Fm7cc5zo=";
  };

  propagatedBuildInputs = [
    urllib3
    sqlalchemy
    geojson
  ];

  nativeCheckInputs = [
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
  ];

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
