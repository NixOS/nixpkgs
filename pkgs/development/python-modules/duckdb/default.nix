{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cmake,
  ninja,
  duckdb,
  fsspec,
  google-cloud-storage,
  ipython,
  numpy,
  openssl,
  pandas,
  psutil,
  pyarrow,
  pybind11,
  scikit-build-core,
  setuptools-scm,
  pytest-reraise,
  pytestCheckHook,
}:

buildPythonPackage rec {
  inherit (duckdb)
    pname
    version
    ;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duckdb";
    repo = "duckdb-python";
    tag = "v${version}";
    hash = "sha256-cZyiTqu5iW/cqEo42b/XnOG7hJqtQs1h2RXXL392ujA=";
  };

  postPatch = ''
    # patch cmake to ignore absence of git submodule copy of duckdb
    substituteInPlace cmake/duckdb_loader.cmake \
      --replace-fail '"''${CMAKE_CURRENT_SOURCE_DIR}/external/duckdb"' \
                     '"${duckdb.src}"'

    # replace pybind11[global] with pybind11
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11[global]" "pybind11"

    # replace custom build backend with standard scikit-build-core
    substituteInPlace pyproject.toml \
      --replace-fail 'build-backend = "duckdb_packaging.build_backend"' \
                     'build-backend = "scikit_build_core.build"' \
      --replace-fail 'backend-path = ["./"]' \
                     '# backend-path removed'
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  build-system = [
    pybind11
    scikit-build-core
    setuptools-scm
  ];

  buildInputs = [
    duckdb
    openssl
  ];

  optional-dependencies = {
    # Note: ipython and adbc_driver_manager currently excluded despite inclusion in upstream
    # https://github.com/duckdb/duckdb-python/blob/v1.4.0/pyproject.toml#L44-L52
    all = [
      ipython
      fsspec
      numpy
    ]
    ++ lib.optionals (pythonOlder "3.14") [
      # https://github.com/duckdb/duckdb-python/blob/0ee500cfa35fc07bf81ed02e8ab6984ea1f665fd/pyproject.toml#L49-L51
      # adbc_driver_manager noted for migration to duckdb C source
      pandas
      pyarrow
    ];
  };

  env = {
    DUCKDB_BUILD_UNITY = 1;
    # default to disabled extension autoload/autoinstall
    CMAKE_DEFINE_DUCKDB_EXTENSION_AUTOLOAD_DEFAULT = "0";
    CMAKE_DEFINE_DUCKDB_EXTENSION_AUTOINSTALL_DEFAULT = "0";
  };

  cmakeFlags = [
    (lib.cmakeFeature "OVERRIDE_GIT_DESCRIBE" "v${version}-0-g${duckdb.rev}")
  ];

  nativeCheckInputs = [
    fsspec
    google-cloud-storage
    psutil
    pytest-reraise
    pytestCheckHook
  ]
  ++ optional-dependencies.all;

  pytestFlags = [ "--verbose" ];

  # test flags from .github/workflows/Python.yml
  pytestFlagsArray = [ "--verbose" ];
  enabledTestPaths = if stdenv.hostPlatform.isDarwin then [ "tests/fast" ] else [ "tests" ];

  disabledTestPaths = [
    # avoid dependency on adbc_driver_manager
    "tests/fast/adbc"
    # avoid dependency on pyotp
    "tests/fast/test_pypi_cleanup.py"
    # avoid test data download requiring network access
    "tests/slow/test_h2oai_arrow.py"
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

    # flaky due to a race condition in checking whether a thread is alive
    "test_query_progress"
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
