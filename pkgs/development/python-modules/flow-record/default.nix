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
  pytz,
  setuptools-scm,
  setuptools,
  structlog,
  tqdm,
  zstandard,
}:

buildPythonPackage rec {
  pname = "flow-record";
  version = "3.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "flow.record";
    tag = version;
    hash = "sha256-hJZCWF81pMeHOZGc6zTA046hV1J0PNQGMlPD3mgyrRI=";
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
    # xlsx = [ openpyxl ]; # Not available
    full = [
      structlog
      tqdm
    ]
    ++ optional-dependencies.compression;
  };

  nativeCheckInputs = [
    elastic-transport
    pytest7CheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "flow.record" ];

  disabledTestPaths = [
    # Input not available
    "tests/adapter/test_xlsx.py"
    # Requires rdump
    "tests/tools/test_rdump.py"
  ];

  disabledTests = [ "test_rdump_fieldtype_path_json" ];

  meta = with lib; {
    description = "Library for defining and creating structured data";
    homepage = "https://github.com/fox-it/flow.record";
    changelog = "https://github.com/fox-it/flow.record/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
