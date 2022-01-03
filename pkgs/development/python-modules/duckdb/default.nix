{ lib
, buildPythonPackage
, duckdb
, mypy
, numpy
, pandas
, pybind11
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "duckdb";
  inherit (duckdb) version src;
  format = "setuptools";

  sourceRoot = "source/tools/pythonpkg";

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    pybind11
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    pandas
  ];

  checkInputs = [
    mypy
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "duckdb"
  ];

  meta = with lib; {
    description = "Python binding for DuckDB";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
