{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cmake,
  ninja,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "real-ladybug";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LadybugDB";
    repo = "ladybug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tq7a7XOKoxe0/cdZehNAEX4ENHIjMFdBBARNzZiuMM8=";
  };

  sourceRoot = "${finalAttrs.src.name}/tools/python_api";

  postUnpack = ''
    chmod -R +w ${finalAttrs.src.name}
  '';

  postPatch = ''
        substituteInPlace pyproject.toml \
          --replace-fail 'version = "0.0.1"' 'version = "${finalAttrs.version}"'

        cat >> pyproject.toml << 'TOML'

    [tool.setuptools.package-data]
    real_ladybug = ["*.so", "*.dylib", "*.pyd"]
    TOML
  '';

  build-system = [ setuptools ];

  # cmake and ninja are needed for preBuild which compiles the C++ engine
  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    cmake -S ../.. -B ../../cmake-build -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_PYTHON=TRUE \
      -DBUILD_SHELL=FALSE
    cmake --build ../../cmake-build
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "test/"
  ];

  disabledTests = [
    # Subprocess tests spawn new processes where build_dir may not resolve
    "test_database_close"
    "test_database_context_manager"
  ];

  disabledTestPaths = [
    # Tests requiring dataset fixtures (conn_db_readonly/conn_db_readwrite)
    # which fail due to path resolution issues in init_demo within the sandbox
    "test/test_arrow.py"
    "test/test_async_connection.py"
    "test/test_connection.py"
    "test/test_datatype.py"
    "test/test_df.py"
    "test/test_exception.py"
    "test/test_get_header.py"
    "test/test_issue.py"
    "test/test_networkx.py"
    "test/test_parameter.py"
    "test/test_prepared_statement.py"
    "test/test_query_result.py"
    "test/test_timeout.py"
    "test/test_udf.py"
    # Tests requiring optional dependencies (pandas, polars, pyarrow, torch)
    "test/test_scan_pandas.py"
    "test/test_scan_pandas_pyarrow.py"
    "test/test_scan_polars.py"
    "test/test_scan_pyarrow.py"
    "test/test_torch_geometric.py"
    "test/test_torch_geometric_remote_backend.py"
    # Subprocess tests that spawn new Python processes with build_dir
    "test/test_query_result_close.py"
    "test/test_wal.py"
  ];

  pythonImportsCheck = [ "real_ladybug" ];

  meta = {
    description = "Python bindings for LadybugDB, an embeddable property graph database management system (fork of Kuzu)";
    homepage = "https://ladybugdb.com/";
    changelog = "https://github.com/LadybugDB/ladybug/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hamidr ];
  };
})
