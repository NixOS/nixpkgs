{ lib, buildPythonPackage, python, isPy3k, fetchurl, arrow-cpp, cmake, cython, futures, hypothesis, numpy, pandas, pytest, pkgconfig, setuptools_scm, six }:

let
  _arrow-cpp = arrow-cpp.override { inherit python; };
in

buildPythonPackage rec {
  pname = "pyarrow";

  inherit (_arrow-cpp) version src;

  sourceRoot = "apache-arrow-${version}/python";

  nativeBuildInputs = [ cmake cython pkgconfig setuptools_scm ];
  propagatedBuildInputs = [ numpy six ] ++ lib.optionals (!isPy3k) [ futures ];
  checkInputs = [ hypothesis pandas pytest ];

  PYARROW_BUILD_TYPE = "release";
  PYARROW_CMAKE_OPTIONS = [
    "-DCMAKE_INSTALL_RPATH=${ARROW_HOME}/lib"

    # This doesn't use setup hook to call cmake so we need to workaround #54606
    # ourselves
    "-DCMAKE_POLICY_DEFAULT_CMP0025=NEW"
  ];

  preCheck = ''
    rm pyarrow/tests/test_jvm.py
    rm pyarrow/tests/test_hdfs.py
    rm pyarrow/tests/test_cuda.py

    # fails: "ArrowNotImplementedError: Unsupported numpy type 22"
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_timedelta_with_nulls" "_disabled"

    # runs out of memory on @grahamcofborg linux box
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_large_dataframe" "_disabled"

    # probably broken on python2
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_unicode_filename" "_disabled"

    # fails "error: [Errno 2] No such file or directory: 'test'" because
    # nix_run_setup invocation somehow manages to import deserialize_buffer.py
    # when it is not intended to be imported at all
    rm pyarrow/tests/deserialize_buffer.py
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_deserialize_buffer_in_different_process" "_disabled"
  '';

  ARROW_HOME = _arrow-cpp;
  PARQUET_HOME = _arrow-cpp;

  setupPyBuildFlags = ["--with-parquet" ];

  checkPhase = ''
    mv pyarrow/tests tests
    rm -rf pyarrow
    mkdir pyarrow
    mv tests pyarrow/tests
    pytest -v
  '';

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = https://arrow.apache.org/;
    license = lib.licenses.asl20;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
