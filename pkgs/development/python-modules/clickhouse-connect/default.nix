{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  # build_requires
  cython,
  # install_requires
  certifi,
  importlib-metadata,
  urllib3,
  pytz,
  zstandard,
  lz4,
  # extras_require
  sqlalchemy,
  numpy,
  pandas,
  pyarrow,
  orjson,
  # not in tests_require, but should be
  pytest-dotenv,
}:
buildPythonPackage rec {
  pname = "clickhouse-connect";
  version = "0.10.0";

  format = "setuptools";

  src = fetchFromGitHub {
    repo = "clickhouse-connect";
    owner = "ClickHouse";
    tag = "v${version}";
    hash = "sha256-D2D0sOFb0gcbLfMigYn0/GrT8zJav2Q6T39dONLxui4=";
  };

  nativeBuildInputs = [ cython ];
  setupPyBuildFlags = [ "--inplace" ];
  enableParallelBuilding = true;

  propagatedBuildInputs = [
    certifi
    importlib-metadata
    urllib3
    pytz
    zstandard
    lz4
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-dotenv
  ]
  ++ optional-dependencies.sqlalchemy
  ++ optional-dependencies.numpy;

  # these tests require a running clickhouse instance
  disabledTestPaths = [
    "tests/integration_tests"
  ];

  pythonImportsCheck = [
    "clickhouse_connect"
    "clickhouse_connect.driverc.buffer"
    "clickhouse_connect.driverc.dataconv"
    "clickhouse_connect.driverc.npconv"
  ];

  optional-dependencies = {
    sqlalchemy = [ sqlalchemy ];
    numpy = [ numpy ];
    pandas = [ pandas ];
    arrow = [ pyarrow ];
    orjson = [ orjson ];
  };

  meta = {
    description = "ClickHouse Database Core Driver for Python, Pandas, and Superset";
    homepage = "https://github.com/ClickHouse/clickhouse-connect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
