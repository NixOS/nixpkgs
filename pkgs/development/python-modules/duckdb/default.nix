{ lib
, buildPythonPackage
, fetchpatch
, duckdb
, google-cloud-storage
, mypy
, numpy
, pandas
, psutil
, pybind11
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "duckdb";
  inherit (duckdb) version src patches;
  format = "setuptools";

  preConfigure = ''
    cd tools/pythonpkg
    substituteInPlace setup.py --replace "multiprocessing.cpu_count()" "$NIX_BUILD_CORES"
  '';

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
    google-cloud-storage
    mypy
    psutil
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "duckdb"
  ];

  meta = with lib; {
    description = "Python binding for DuckDB";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc cpcloud ];
  };
}
