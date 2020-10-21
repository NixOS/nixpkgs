{ stdenv, lib, fetchurl, fetchFromGitHub, fetchpatch, fixDarwinDylibNames
, autoconf, boost, brotli, cmake, flatbuffers, gflags, glog, gtest, lz4
, perl, python3, rapidjson, snappy, thrift, utf8proc, which, zlib, zstd
, enableShared ? true }:

let
  arrow-testing = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-testing";
    rev = "f552c4dcd2ae3d14048abd20919748cce5276ade";
    sha256 = "1smaidk5k2q6xdav7qp74ak34vvwv5qyfqw0szi573awsrsrahr8";
  };

  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "bcd9ebcf9204a346df47204fe21b85c8d0498816";
    sha256 = "0m16pqzbvxiaradq088q5ai6fwnz9srbap996397znwppvva479b";
  };

in stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "1.0.1";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "0p67dni8dwqbwq96gfdq3pyk799id6dgdl9h7cpp9icsjsmad70l";
  };
  sourceRoot = "apache-arrow-${version}/cpp";

  ARROW_JEMALLOC_URL = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2";
    sha256 = "1xl7z0vwbn5iycg7amka9jd6hxd8nmfk7nahi4p9w2bnw9f0wcrl";
  };

  ARROW_MIMALLOC_URL = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/microsoft/mimalloc/archive/v1.6.3.tar.gz";
    sha256 = "0pia8b4acv1w8qzcpc9i1a2fasnn3rmp996k0l87p2di0lbls0w5";
  };

  patches = [
    # patch to fix python-test
    ./darwin.patch
    # Properly exported static targets. Remove at the next version bump.
    (fetchpatch {
      url = "https://github.com/apache/arrow/commit/b040600b39a4f803b704934252665f9440dd1276.patch";
      sha256 = "1mvw29ybcsz77zprmsk41blxmrj8ywayg7ghf6xkkf98907ws8m8";
      includes = [ "*.cmake" ];
      stripLen = 1;
    })
    (fetchpatch {
      url = "https://github.com/apache/arrow/commit/81d3f2657b17436d6d5a6af9aaf6f36c3f5e4ac9.patch";
      sha256 = "18fmzr5f79hvx2qpyfgvvl98p4zgzfxrmrd1d2basp0w0da1ciqs";
      includes = [ "*CMakeLists.txt" "*.cmake" "*.cmake.in" ];
      stripLen = 1;
    })
  ];

  nativeBuildInputs = [
    cmake
    autoconf # for vendored jemalloc
    flatbuffers
  ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [
    boost
    brotli
    flatbuffers
    gflags
    glog
    gtest
    lz4
    rapidjson
    snappy
    thrift
    utf8proc
    zlib
    zstd
  ] ++ lib.optionals enableShared [
    python3.pkgs.python
    python3.pkgs.numpy
  ];

  preConfigure = ''
    patchShebangs build-support/
  '';

  cmakeFlags = [
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-DARROW_BUILD_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_BUILD_STATIC=${if enableShared then "OFF" else "ON"}"
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_VERBOSE_THIRDPARTY_BUILD=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-DARROW_DEPENDENCY_USE_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_PLASMA=ON"
    # Disable Python for static mode because openblas is currently broken there.
    "-DARROW_PYTHON=${if enableShared then "ON" else "OFF"}"
    "-DARROW_USE_GLOG=ON"
    "-DARROW_WITH_BROTLI=ON"
    "-DARROW_WITH_LZ4=ON"
    "-DARROW_WITH_SNAPPY=ON"
    "-DARROW_WITH_UTF8PROC=ON"
    "-DARROW_WITH_ZLIB=ON"
    "-DARROW_WITH_ZSTD=ON"
    "-DARROW_MIMALLOC=ON"
    # Parquet options:
    "-DARROW_PARQUET=ON"
    "-DPARQUET_BUILD_EXECUTABLES=ON"
  ] ++ lib.optionals (!enableShared) [
    "-DARROW_TEST_LINKAGE=static"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # needed for tests
    "-DCMAKE_INSTALL_RPATH=@loader_path/../lib" # needed for tools executables
  ] ++ lib.optional (!stdenv.isx86_64) "-DARROW_USE_SIMD=OFF";

  doInstallCheck = true;
  ARROW_TEST_DATA =
    if doInstallCheck then "${arrow-testing}/data" else null;
  PARQUET_TEST_DATA =
    if doInstallCheck then "${parquet-testing}/data" else null;
  installCheckInputs = [ perl which ];
  installCheckPhase =
  let
    excludedTests = lib.optionals stdenv.isDarwin [
      # Some plasma tests need to be patched to use a shorter AF_UNIX socket
      # path on Darwin. See https://github.com/NixOS/nix/pull/1085
      "plasma-external-store-tests"
      "plasma-client-tests"
    ];
  in ''
    ctest -L unittest -V \
      --exclude-regex '^(${builtins.concatStringsSep "|" excludedTests})$'
  '';

  meta = {
    description = "A  cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tobim veprbl ];
  };
}
