{
  lib,
  buildPythonPackage,
  dask,
  duckdb,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  pandas,
  polars,
  pyarrow,
  pyspark,
  pytest-env,
  pytestCheckHook,
  sqlframe,
}:

buildPythonPackage rec {
  pname = "narwhals";
  version = "1.38.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "narwhals-dev";
    repo = "narwhals";
    tag = "v${version}";
    hash = "sha256-zqtYTqirAXLcpFA2sXczl0HPWL/3cYWws2yUfE8I8NY=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    # cudf = [ cudf ];
    dask = [ dask ] ++ dask.optional-dependencies.dataframe;
    # modin = [ modin ];
    pandas = [ pandas ];
    polars = [ polars ];
    pyarrow = [ pyarrow ];
    pyspark = [ pyspark ];
    sqlframe = [ sqlframe ];
  };

  nativeCheckInputs = [
    duckdb
    hypothesis
    pytest-env
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "narwhals" ];

  disabledTests = [
    # Flaky
    "test_rolling_var_hypothesis"
    # Missing file
    "test_pyspark_connect_deps_2517"
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = {
    description = "Lightweight and extensible compatibility layer between dataframe libraries";
    homepage = "https://github.com/narwhals-dev/narwhals";
    changelog = "https://github.com/narwhals-dev/narwhals/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
