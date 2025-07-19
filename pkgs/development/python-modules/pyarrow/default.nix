{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  pythonAtLeast,
  pythonOlder,
  arrow-cpp,
  cffi,
  cloudpickle,
  cmake,
  cython,
  fsspec,
  hypothesis,
  numpy,
  pandas,
  pytestCheckHook,
  pytest-lazy-fixture,
  pkg-config,
  setuptools,
  setuptools-scm,
  oldest-supported-numpy,
}:

let
  zero_or_one = cond: if cond then 1 else 0;
in

buildPythonPackage rec {
  pname = "pyarrow";
  inherit (arrow-cpp) version src;
  pyproject = true;

  disabled = pythonOlder "3.7";

  sourceRoot = "${src.name}/python";

  nativeBuildInputs = [
    cmake
    cython
    pkg-config
    setuptools
    setuptools-scm
    oldest-supported-numpy
  ];

  buildInputs = [ arrow-cpp ];

  propagatedBuildInputs = [
    cffi
    numpy
  ];

  checkInputs = [
    cloudpickle
    fsspec
  ];

  nativeCheckInputs = [
    hypothesis
    pandas
    pytestCheckHook
    pytest-lazy-fixture
  ];

  PYARROW_BUILD_TYPE = "release";

  PYARROW_WITH_DATASET = zero_or_one true;
  PYARROW_WITH_FLIGHT = zero_or_one arrow-cpp.enableFlight;
  PYARROW_WITH_HDFS = zero_or_one true;
  PYARROW_WITH_PARQUET = zero_or_one true;
  PYARROW_WITH_PARQUET_ENCRYPTION = zero_or_one true;
  PYARROW_WITH_S3 = zero_or_one arrow-cpp.enableS3;
  PYARROW_WITH_GCS = zero_or_one arrow-cpp.enableGcs;
  PYARROW_BUNDLE_ARROW_CPP_HEADERS = zero_or_one false;

  PYARROW_CMAKE_OPTIONS = [ "-DCMAKE_INSTALL_RPATH=${ARROW_HOME}/lib" ];

  ARROW_HOME = arrow-cpp;
  PARQUET_HOME = arrow-cpp;

  ARROW_TEST_DATA = lib.optionalString doCheck arrow-cpp.ARROW_TEST_DATA;
  doCheck = true;

  dontUseCmakeConfigure = true;

  __darwinAllowLocalNetworking = true;

  preBuild = ''
    export PYARROW_PARALLEL=$NIX_BUILD_CORES
  '';

  postInstall = ''
    # copy the pyarrow C++ header files to the appropriate location
    pyarrow_include="$out/${python.sitePackages}/pyarrow/include"
    mkdir -p "$pyarrow_include/arrow/python"
    find "$PWD/pyarrow/src/arrow" -type f -name '*.h' -exec cp {} "$pyarrow_include/arrow/python" \;
  '';

  disabledTestPaths = [
    # These tests require access to s3 via the internet.
    "pyarrow/tests/test_fs.py::test_resolve_s3_region"
    "pyarrow/tests/test_fs.py::test_s3_finalize"
    "pyarrow/tests/test_fs.py::test_s3_finalize_region_resolver"
    "pyarrow/tests/test_fs.py::test_s3_real_aws"
    "pyarrow/tests/test_fs.py::test_s3_real_aws_region_selection"
    "pyarrow/tests/test_fs.py::test_s3_options"
    # Flaky test
    "pyarrow/tests/test_flight.py::test_roundtrip_errors"
    "pyarrow/tests/test_pandas.py::test_threaded_pandas_import"
    # Flaky test, works locally but not on Hydra.
    "pyarrow/tests/test_csv.py::TestThreadedCSVTableRead::test_cancellation"
    # expects arrow-cpp headers to be bundled.
    "pyarrow/tests/test_cpp_internals.py::test_pyarrow_include"
    # Searches for TZDATA in /usr.
    "pyarrow/tests/test_orc.py::test_example_using_json"
    # AssertionError: assert 'Europe/Monaco' == 'Europe/Paris'
    "pyarrow/tests/test_types.py::test_dateutil_tzinfo_to_string"
    # These fail with xxx_fixture not found.
    # xxx = unary_func, unary_agg_func, varargs_agg_func
    "pyarrow/tests/test_substrait.py::test_udf_via_substrait"
    "pyarrow/tests/test_substrait.py::test_scalar_aggregate_udf_basic"
    "pyarrow/tests/test_substrait.py::test_hash_aggregate_udf_basic"
    "pyarrow/tests/test_udf.py::test_hash_agg_basic"
    "pyarrow/tests/test_udf.py::test_hash_agg_empty"
    "pyarrow/tests/test_udf.py::test_input_lifetime"
    "pyarrow/tests/test_udf.py::test_scalar_agg_basic"
    "pyarrow/tests/test_udf.py::test_scalar_agg_empty"
    "pyarrow/tests/test_udf.py::test_scalar_agg_varargs"
    "pyarrow/tests/test_udf.py::test_scalar_input"
    "pyarrow/tests/test_udf.py::test_scalar_udf_context"
    "pyarrow/tests/test_udf.py::test_udf_array_unary"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Requires loopback networking.
    "pyarrow/tests/test_ipc.py::test_socket_"
    "pyarrow/tests/test_flight.py::test_never_sends_data"
    "pyarrow/tests/test_flight.py::test_large_descriptor"
    "pyarrow/tests/test_flight.py::test_large_metadata_client"
    "pyarrow/tests/test_flight.py::test_none_action_side_effect"
    # Fails to compile.
    "pyarrow/tests/test_cython.py::test_cython_api"
  ]
  ++ lib.optionals (pythonAtLeast "3.11") [
    # Repr output is printing number instead of enum name so these tests fail
    "pyarrow/tests/test_fs.py::test_get_file_info"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # This test requires local networking.
    "pyarrow/tests/test_fs.py::test_filesystem_from_uri_gcs"
  ];

  disabledTests = [ "GcsFileSystem" ];

  preCheck = ''
    export PARQUET_TEST_DATA="${arrow-cpp.PARQUET_TEST_DATA}"
    shopt -s extglob
    rm -r pyarrow/!(conftest.py|tests)
    mv pyarrow/conftest.py pyarrow/tests/parent_conftest.py
    substituteInPlace pyarrow/tests/conftest.py --replace-fail ..conftest .parent_conftest
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # OSError: [Errno 24] Too many open files
    ulimit -n 1024
  '';

  pythonImportsCheck = [
    "pyarrow"
  ]
  ++ map (module: "pyarrow.${module}") [
    "compute"
    "csv"
    "dataset"
    "feather"
    "flight"
    "fs"
    "json"
    "orc"
    "parquet"
  ];

  meta = with lib; {
    description = "Cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      veprbl
      cpcloud
    ];
  };
}
