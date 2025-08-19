{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  dask,
  urllib3,
  geojson,
  verlib2,
  pueblo,
  pandas,
  pythonOlder,
  sqlalchemy,
  pytestCheckHook,
  pytz,
  setuptools,
  orjson,
}:

buildPythonPackage rec {
  pname = "crate";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "crate";
    repo = "crate-python";
    tag = version;
    hash = "sha256-K09jezBINTw4sUl1Xvm4lJa68ZpwMy9ju/pxdRwnaE4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    orjson
    urllib3
    sqlalchemy
    geojson
    verlib2
    pueblo
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
  ];

  disabledTestPaths = [
    # imports setuptools.ssl_support, which doesn't exist anymore
    "tests/client/test_http.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/crate/crate-python";
    description = "Python client library for CrateDB";
    changelog = "https://github.com/crate/crate-python/blob/${version}/CHANGES.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
