{
  lib,
  buildPythonPackage,
  # cudf,
  dask,
  dask-expr,
  duckdb,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  # modin,
  pandas,
  polars,
  pyarrow,
  pytest-env,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "narwhals";
  version = "1.22.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "narwhals-dev";
    repo = "narwhals";
    tag = "v${version}";
    hash = "sha256-I6nJJiiW1v04YH70OPxXKeO80N52nnCPKRzJLILEWmw=";
  };

  build-system = [
    hatchling
  ];

  optional-dependencies = {
    # cudf = [ cudf ];
    dask = [
      dask
      dask-expr
    ];
    # modin = [ modin ];
    pandas = [ pandas ];
    polars = [ polars ];
    pyarrow = [ pyarrow ];
  };

  nativeCheckInputs = [
    duckdb
    hypothesis
    pytest-env
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "narwhals" ];

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
