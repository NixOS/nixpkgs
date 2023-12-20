{ lib
, stdenv
, buildPythonPackage
, python
, pythonAtLeast
, pythonOlder
, arrow-cpp
, cffi
, cloudpickle
, cmake
, cython
, fsspec
, hypothesis
, numpy
, pandas
, pytestCheckHook
, pytest-lazy-fixture
, pkg-config
, scipy
, fetchpatch
, setuptools-scm
}:

let
  zero_or_one = cond: if cond then 1 else 0;
in

buildPythonPackage rec {
  pname = "pyarrow";
  format = "setuptools";
  inherit (arrow-cpp) version src;

  disabled = pythonOlder "3.7";

  sourceRoot = "apache-arrow-${version}/python";

  nativeBuildInputs = [
    cmake
    cython
    pkg-config
    setuptools-scm
  ];

  buildInputs = [ arrow-cpp ];

  propagatedBuildInputs = [
    cffi
    cloudpickle
    fsspec
    numpy
    scipy
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
  # Plasma is deprecated since arrow 10.0.0
  PYARROW_WITH_PLASMA = zero_or_one false;
  PYARROW_WITH_S3 = zero_or_one arrow-cpp.enableS3;
  PYARROW_WITH_GCS = zero_or_one arrow-cpp.enableGcs;
  PYARROW_BUNDLE_ARROW_CPP_HEADERS = zero_or_one false;

  PYARROW_CMAKE_OPTIONS = [
    "-DCMAKE_INSTALL_RPATH=${ARROW_HOME}/lib"
  ];

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

  pytestFlagsArray = [
    # A couple of tests are missing fixture imports, luckily pytest offers a
    # clean solution.
    "--fixtures pyarrow/tests/conftest.py"
    # Deselect a single test because pyarrow prints a 2-line error message where
    # only a single line is expected. The additional line of output comes from
    # the glog library which is an optional dependency of arrow-cpp that is
    # enabled in nixpkgs.
    # Upstream Issue: https://issues.apache.org/jira/browse/ARROW-11393
    "--deselect=pyarrow/tests/test_memory.py::test_env_var"
    # these tests require access to s3 via the internet
    "--deselect=pyarrow/tests/test_fs.py::test_resolve_s3_region"
    "--deselect=pyarrow/tests/test_fs.py::test_s3_real_aws"
    "--deselect=pyarrow/tests/test_fs.py::test_s3_real_aws_region_selection"
    "--deselect=pyarrow/tests/test_fs.py::test_s3_options"
    # Flaky test
    "--deselect=pyarrow/tests/test_flight.py::test_roundtrip_errors"
    "--deselect=pyarrow/tests/test_pandas.py::test_threaded_pandas_import"
    # Flaky test, works locally but not on Hydra
    "--deselect=pyarrow/tests/test_csv.py::TestThreadedCSVTableRead::test_cancellation"
    # expects arrow-cpp headers to be bundled
    "--deselect=pyarrow/tests/test_cpp_internals.py::test_pyarrow_include"
  ] ++ lib.optionals stdenv.isDarwin [
    # Requires loopback networking
    "--deselect=pyarrow/tests/test_ipc.py::test_socket_"
    "--deselect=pyarrow/tests/test_flight.py::test_never_sends_data"
    "--deselect=pyarrow/tests/test_flight.py::test_large_descriptor"
    "--deselect=pyarrow/tests/test_flight.py::test_large_metadata_client"
    "--deselect=pyarrow/tests/test_flight.py::test_none_action_side_effect"
    # fails to compile
    "--deselect=pyarrow/tests/test_cython.py::test_cython_api"
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # Repr output is printing number instead of enum name so these tests fail
    "--deselect=pyarrow/tests/test_fs.py::test_get_file_info"
  ] ++ lib.optionals stdenv.isLinux [
    # this test requires local networking
    "--deselect=pyarrow/tests/test_fs.py::test_filesystem_from_uri_gcs"
  ];

  disabledTests = [ "GcsFileSystem" ];

  dontUseSetuptoolsCheck = true;

  preCheck = ''
    shopt -s extglob
    rm -r pyarrow/!(conftest.py|tests)
    mv pyarrow/conftest.py pyarrow/tests/parent_conftest.py
    substituteInPlace pyarrow/tests/conftest.py --replace ..conftest .parent_conftest
  '' + lib.optionalString stdenv.isDarwin ''
    # OSError: [Errno 24] Too many open files
    ulimit -n 1024
  '';

  pythonImportsCheck = [
    "pyarrow"
  ] ++ map (module: "pyarrow.${module}") [
    "compute"
    "csv"
    "dataset"
    "feather"
    "flight"
    "fs"
    "hdfs"
    "json"
    "parquet"
  ];

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl cpcloud ];
  };
}
