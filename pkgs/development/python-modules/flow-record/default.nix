{
  lib,
  buildPythonPackage,
  duckdb,
  elastic-transport,
  elasticsearch,
  fastavro,
  fetchFromGitHub,
  httpx,
  lz4,
  maxminddb,
  msgpack,
  pytest7CheckHook,
  pythonOlder,
  pytz,
  setuptools-scm,
  setuptools,
  zstandard,
}:

buildPythonPackage rec {
  pname = "flow-record";
  version = "3.18";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "flow.record";
    rev = "refs/tags/${version}";
    hash = "sha256-tEKmwDZOoGIXfJqxIat6WTbEv4EkiwkJGMpNxfv2Zd0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ msgpack ];

  optional-dependencies = {
    compression = [
      lz4
      zstandard
    ];
    duckdb = [
      duckdb
      pytz
    ];
    elastic = [ elasticsearch ];
    geoip = [ maxminddb ];
    avro = [ fastavro ] ++ fastavro.optional-dependencies.snappy;
    splunk = [ httpx ];
  };

  nativeCheckInputs = [
    elastic-transport
    pytest7CheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "flow.record" ];

  disabledTestPaths = [
    # Test requires rdump
    "tests/test_rdump.py"
  ];

  disabledTests = [ "test_rdump_fieldtype_path_json" ];

  meta = with lib; {
    description = "Library for defining and creating structured data";
    homepage = "https://github.com/fox-it/flow.record";
    changelog = "https://github.com/fox-it/flow.record/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
