{
  lib,
  stdenv,
  buildPythonPackage,
  duckdb,
  fsspec,
  google-cloud-storage,
  numpy,
  openssl,
  pandas,
  psutil,
  pybind11,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  inherit (duckdb)
    patches
    pname
    rev
    src
    version
    ;
  pyproject = true;

  postPatch =
    (duckdb.postPatch or "")
    + ''
      # we can't use sourceRoot otherwise patches don't apply, because the patches apply to the C++ library
      cd tools/pythonpkg

      # 1. let nix control build cores
      # 2. default to extension autoload & autoinstall disabled
      substituteInPlace setup.py \
        --replace-fail "ParallelCompile()" 'ParallelCompile("NIX_BUILD_CORES")' \
        --replace-fail "define_macros.extend([('DUCKDB_EXTENSION_AUTOLOAD_DEFAULT', '1'), ('DUCKDB_EXTENSION_AUTOINSTALL_DEFAULT', '1')])" "pass"
    '';

  env = {
    BUILD_HTTPFS = 1;
    DUCKDB_BUILD_UNITY = 1;
    OVERRIDE_GIT_DESCRIBE = "v${version}-0-g${rev}";
  };

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

  # test flags from .github/workflows/Python.yml
  pytestFlagsArray = [ "--verbose" ] ++ lib.optionals stdenv.isDarwin [ "tests/fast" ];

  disabledTestPaths = [
    # avoid dependency on mypy
    "tests/stubs/test_stubs.py"
  ];

  disabledTests = [
    # tries to make http request
    "test_install_non_existent_extension"

    # test is flaky https://github.com/duckdb/duckdb/issues/11961
    "test_fetchmany"

    # https://github.com/duckdb/duckdb/issues/10702
    # tests are racy and interrupt can be delivered before or after target point
    # causing a later test to fail with a spurious KeyboardInterrupt
    "test_connection_interrupt"
    "test_query_interruption"
  ];

  # remove duckdb dir to prevent import confusion by pytest
  preCheck = ''
    export HOME="$(mktemp -d)"
    rm -rf duckdb
  '';

  pythonImportsCheck = [ "duckdb" ];

  meta = with lib; {
    description = "Python binding for DuckDB";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
