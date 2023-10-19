{ lib
, buildPythonPackage
, duckdb
, fsspec
, google-cloud-storage
, numpy
, openssl
, pandas
, psutil
, pybind11
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  inherit (duckdb) pname version src patches;
  format = "setuptools";

  postPatch = ''
    # we can't use sourceRoot otherwise patches don't apply, because the patches apply to the C++ library
    cd tools/pythonpkg

    # 1. let nix control build cores
    # 2. unconstrain setuptools_scm version
    substituteInPlace setup.py \
      --replace "multiprocessing.cpu_count()" "$NIX_BUILD_CORES"

    # avoid dependency on mypy
    rm tests/stubs/test_stubs.py
  '';

  BUILD_HTTPFS = 1;
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    pybind11
    setuptools-scm
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [
    numpy
    pandas
  ];

  nativeCheckInputs = [
    fsspec
    google-cloud-storage
    psutil
    pytestCheckHook
  ];

  disabledTests = [
    # tries to make http request
    "test_install_non_existent_extension"
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  setupPyBuildFlags = [
    "--inplace"
  ];

  pythonImportsCheck = [
    "duckdb"
  ];

  meta = with lib; {
    description = "Python binding for DuckDB";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
