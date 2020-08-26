{ lib, buildPythonPackage, python, isPy3k, arrow-cpp, cmake, cython, futures, hypothesis, numpy, pandas, pytestCheckHook, pytest-lazy-fixture, pkgconfig, setuptools_scm, six }:

let
  _arrow-cpp = arrow-cpp.override { python3 = python; };
in

buildPythonPackage rec {
  pname = "pyarrow";
  disabled = !isPy3k;

  inherit (_arrow-cpp) version src;

  sourceRoot = "apache-arrow-${version}/python";

  nativeBuildInputs = [ cmake cython pkgconfig setuptools_scm ];
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
    license = lib.licenses.asl20;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
