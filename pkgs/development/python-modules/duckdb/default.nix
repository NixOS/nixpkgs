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
  inherit (duckdb) pname version src patches;
  format = "setuptools";

  # we can't use sourceRoot otherwise patches don't apply, because the patches
  # apply to the C++ library
  postPatch = ''
    cd tools/pythonpkg

    # 1. let nix control build cores
    # 2. unconstrain setuptools_scm version
    substituteInPlace setup.py \
      --replace "multiprocessing.cpu_count()" "$NIX_BUILD_CORES" \
      --replace "setuptools_scm<7.0.0" "setuptools_scm"
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

  nativeCheckInputs = [
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
