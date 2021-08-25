{ lib, buildPythonPackage, python, isPy3k, arrow-cpp, cmake, cython, hypothesis, numpy, pandas, pytestCheckHook, pytest-lazy-fixture, pkg-config, setuptools-scm, six }:

let
  _arrow-cpp = arrow-cpp.override { python3 = python; };
in

buildPythonPackage rec {
  pname = "pyarrow";
  disabled = !isPy3k;

  inherit (_arrow-cpp) version src;

  sourceRoot = "apache-arrow-${version}/python";

  nativeBuildInputs = [ cmake cython pkg-config setuptools-scm ];
  propagatedBuildInputs = [ numpy six ];
  checkInputs = [ hypothesis pandas pytestCheckHook pytest-lazy-fixture ];

  PYARROW_BUILD_TYPE = "release";
  PYARROW_WITH_PARQUET = true;
  PYARROW_CMAKE_OPTIONS = [
    "-DCMAKE_INSTALL_RPATH=${ARROW_HOME}/lib"

    # This doesn't use setup hook to call cmake so we need to workaround #54606
    # ourselves
    "-DCMAKE_POLICY_DEFAULT_CMP0025=NEW"
  ];
  ARROW_HOME = _arrow-cpp;
  PARQUET_HOME = _arrow-cpp;

  dontUseCmakeConfigure = true;

  preBuild = ''
    export PYARROW_PARALLEL=$NIX_BUILD_CORES
  '';

  pytestFlagsArray = [
    # Deselect a single test because pyarrow prints a 2-line error message where
    # only a single line is expected. The additional line of output comes from
    # the glog library which is an optional dependency of arrow-cpp that is
    # enabled in nixpkgs.
    # Upstream Issue: https://issues.apache.org/jira/browse/ARROW-11393
    "--deselect=pyarrow/tests/test_memory.py::test_env_var"
    # Deselect a parquet dataset test because it erroneously fails to find the
    # pyarrow._dataset module.
    "--deselect=pyarrow/tests/parquet/test_dataset.py::test_parquet_dataset_deprecated_properties"
  ];

  dontUseSetuptoolsCheck = true;
  preCheck = ''
    mv pyarrow/tests tests
    rm -rf pyarrow
    mkdir pyarrow
    mv tests pyarrow/tests
  '';

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
