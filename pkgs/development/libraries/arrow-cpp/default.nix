{ stdenv, fetchurl, fetchFromGitHub, fixDarwinDylibNames, autoconf, boost
, brotli, cmake, double-conversion, flatbuffers, gflags, glog, gtest, lz4, perl
, python, rapidjson, snappy, thrift, uriparser, which, zlib, zstd }:

let
  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "a277dc4e55ded3e3ea27dab1e4faf98c112442df";
    sha256 = "1yh5a8l4ship36hwmgmp2kl72s5ac9r8ly1qcs650xv2g9q7yhnq";
  };

in stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "0.15.0";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "0n7xrn5490r2snjl45pm2a4pr2x8a29sh8mpyi4nj5pr9f62s1yi";
  };

  sourceRoot = "apache-arrow-${version}/cpp";

  ARROW_JEMALLOC_URL = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/jemalloc/jemalloc/releases/download/5.2.0/jemalloc-5.2.0.tar.bz2";
    sha256 = "1d73a5c5qdrwck0fa5pxz0myizaf3s9alsvhiqwrjahdlr29zgkl";
  };

  patches = [
    # patch to fix python-test
    ./darwin.patch
  ];

  nativeBuildInputs = [
    cmake
    autoconf # for vendored jemalloc
    flatbuffers
  ] ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [
    boost
    brotli
    double-conversion
    flatbuffers
    gflags
    glog
    gtest
    lz4
    rapidjson
    snappy
    thrift
    uriparser
    zlib
    zstd
    python.pkgs.python
    python.pkgs.numpy
  ];

  preConfigure = ''
    substituteInPlace cmake_modules/FindLz4.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY

    patchShebangs build-support/
  '';

  cmakeFlags = [
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-DARROW_PARQUET=ON"
    "-DARROW_PLASMA=ON"
    "-DARROW_PYTHON=ON"
    "-Duriparser_SOURCE=SYSTEM"
  ] ++ stdenv.lib.optional (!stdenv.isx86_64) "-DARROW_USE_SIMD=OFF";

  doInstallCheck = true;
  PARQUET_TEST_DATA =
    if doInstallCheck then "${parquet-testing}/data" else null;
  installCheckInputs = [ perl which ];
  installCheckPhase = (stdenv.lib.optionalString stdenv.isDarwin ''
    for f in release/*test{,s}; do
      install_name_tool -add_rpath "$out"/lib  "$f"
    done
  '')
  + (let
    excludedTests = stdenv.lib.optionals stdenv.isDarwin [
      # Some plasma tests need to be patched to use a shorter AF_UNIX socket
      # path on Darwin. See https://github.com/NixOS/nix/pull/1085
      "plasma-external-store-tests"
      "plasma-client-tests"
    ];
  in ''
    ctest -L unittest -V \
      --exclude-regex '(${builtins.concatStringsSep "|" excludedTests})'
  '');

  meta = {
    description = "A  cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ tobim veprbl ];
  };
}
