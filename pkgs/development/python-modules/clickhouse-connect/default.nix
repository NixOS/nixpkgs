{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  version = "0.7.11";

  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "clickhouse-connect";
    owner = "ClickHouse";
    rev = "refs/tags/v${version}";
    hash = "sha256-Qh1F9dtDg19jr0ic3V+jH3pQczSMqVi7kxD6HG2llyA=";
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
  ] ++ passthru.optional-dependencies.sqlalchemy ++ passthru.optional-dependencies.numpy;

  # these tests require a running clickhouse instance
  disabledTestPaths = [
    "tests/integration_tests"
    "tests/tls"
  ];

  pythonImportsCheck = [
    "clickhouse_connect"
    "clickhouse_connect.driverc.buffer"
    "clickhouse_connect.driverc.dataconv"
    "clickhouse_connect.driverc.npconv"
  ];

  passthru = {
    optional-dependencies = {
      sqlalchemy = [ sqlalchemy ];
      numpy = [ numpy ];
      pandas = [ pandas ];
      arrow = [ pyarrow ];
      orjson = [ orjson ];
    };
  };

  meta = with lib; {
    description = "ClickHouse Database Core Driver for Python, Pandas, and Superset";
    homepage = "https://github.com/ClickHouse/clickhouse-connect";
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
