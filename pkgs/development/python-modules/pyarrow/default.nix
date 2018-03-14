{ stdenv
, pkgs
, fetchFromGitHub
, buildPythonPackage
, numpy
, cmake
, boost
, zlib
, thrift
, python
, cython
, setuptools_scm
, pytest
, pandas
, six
}:
let
pythonWithDeps = python.buildEnv.override {
  extraLibs = [ numpy ];
  ignoreCollisions = true;
};
staticSnappy = pkgs.snappy.override { withStatic = true; };
staticLz4 = pkgs.lz4.override { withStatic = true; };
arrow = stdenv.mkDerivation {
  name = "arrow";
  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow";
    rev = "apache-arrow-0.8.0";
    sha256 = "0ggbbvmfwn1bqv8f4j4xsj4s22l9cnx94b2vj4ybr295w0d7ixp5";
  };
  preConfigure = ''
    cd cpp
  '';
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=release"
    "-DARROW_PYTHON=ON"
    # plasma has a compile error with flatbuffers
    "-DARROW_PLASMA=OFF"

    # TODO: The disabled compression codecs require static builds as
    # well which is not generally supported in nixpkgs.
    "-DARROW_WITH_BROTLI=OFF"
    "-DARROW_WITH_ZSTD=OFF"
    "-DARROW_WITH_ZLIB=OFF"
    "-DARROW_BUILD_TESTS=OFF"
    "-DSNAPPY_INCLUDE_DIR=${staticSnappy.dev}/include"
    "-DSNAPPY_HOME=${staticSnappy}"
    "-DLZ4_HOME=${staticLz4.dev}"
    "-DLZ4_STATIC_LIB=${staticLz4}/lib/liblz4.a"
    "-DFLATBUFFERS_HOME=${pkgs.flatbuffers}"
    "-DRAPIDJSON_HOME=${pkgs.rapidjson}"
  ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    pythonWithDeps
  ];
};
parquetCpp = stdenv.mkDerivation {
  name = "parquet-cpp";
  src = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-cpp";
    rev = "f13c61fd4447bee82ffc5807a03b8ba01960430a";
    sha256 = "13maczzhb8bkaws4rpyp1hvb92l1izb9cm95h2dzsvaf5p52z6bh";
  };
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=release"
    "-DPARQUET_BUILD_BENCHMARKS=off"
    "-DPARQUET_BUILD_EXECUTABLES=off"
    "-DPARQUET_BUILD_TESTS=off"
    "-DTHRIFT_INCLUDE_DIR='${pkgs.thrift}/include'"
    "-DTHRIFT_STATIC_LIB='${pkgs.thrift}/lib/libthrift.a'"
    "-DTHRIFT_COMPILER='${pkgs.thrift}/bin/thrift'"
    "-DARROW_HOME=${arrow}"
  ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    (pkgs.thrift.override { withStatic = true; })
  ];
};
in buildPythonPackage rec {
  # Loosely based on the instructions here: https://arrow.apache.org/docs/python/development.html
  name = "${pname}-${version}";
  pname = "pyarrow";
  version = "0.8.0";

  src = arrow.src;

  preBuild = ''
    pushd python
    export ARROW_HOME=${arrow}
    export PARQUET_HOME=${parquetCpp}
    ${python.executable} setup.py build_ext --build-type=release --with-parquet --inplace
  '';

  propagatedBuildInputs = [ numpy six ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    cython
    setuptools_scm
    pytest
    pandas
  ];

  checkPhase = ''
    # test requires gzip which hasn't been enabled yet:
    substituteInPlace pyarrow/tests/test_io.py --replace 'test_compress_decompress' '_test_disabled'
    substituteInPlace pyarrow/tests/test_parquet.py --replace 'test_pandas_parquet_configuration_options' '_test_disabled'
    py.test -v .
  '';

  meta = with stdenv.lib; {
    description = "Apache Arrow is a cross-language development platform for in-memory data.";
    homepage = "https://arrow.apache.org/";
  };
}
