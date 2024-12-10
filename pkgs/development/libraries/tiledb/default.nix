{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  zlib,
  lz4,
  bzip2,
  zstd,
  spdlog,
  tbb,
  openssl,
  boost,
  libpqxx,
  clang-tools,
  catch2_3,
  python3,
  gtest,
  doxygen,
  fixDarwinDylibNames,
  useAVX2 ? stdenv.hostPlatform.avx2Support,
}:

let
  # pre-fetch ExternalProject from cmake/Modules/FindMagic_EP.cmake
  ep-file-windows = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "file-windows";
    rev = "5.38.2.tiledb";
    hash = "sha256-TFn30VCuWZr252VN1T5NNCZe2VEN3xQSomS7XxxKGF8=";
    fetchSubmodules = true;
  };

in
stdenv.mkDerivation rec {
  pname = "tiledb";
  version = "2.18.2";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB";
    rev = version;
    hash = "sha256-uLiXhigYz3v7NgY38twot3sBHxZS5QCrOiPfME4wWzE=";
  };

  patches = [
    ./FindMagic_EP.cmake.patch
  ];

  postPatch = ''
    # copy pre-fetched external project to directory where it is expected to be
    mkdir -p build/externals/src
    cp -a ${ep-file-windows} build/externals/src/ep_magic
    chmod -R u+w build/externals/src/ep_magic

    # add openssl on path
    sed -i '49i list(APPEND OPENSSL_PATHS "${openssl.dev}" "${openssl.out}")' \
      cmake/Modules/FindOpenSSL_EP.cmake
  '';

  # upstream will hopefully fix this in some newer release
  env.CXXFLAGS = "-include random";

  # (bundled) blosc headers have a warning on some archs that it will be using
  # unaccelerated routines.
  cmakeFlags = [
    "-DTILEDB_VCPKG=OFF"
    "-DTILEDB_WEBP=OFF"
    "-DTILEDB_WERROR=OFF"
  ] ++ lib.optional (!useAVX2) "-DCOMPILER_SUPPORTS_AVX2=FALSE";

  nativeBuildInputs = [
    ep-file-windows
    catch2_3
    clang-tools
    cmake
    python3
    doxygen
  ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  nativeCheckInputs = [
    gtest
  ];

  buildInputs = [
    zlib
    lz4
    bzip2
    zstd
    spdlog
    tbb
    openssl
    boost
    libpqxx
  ];

  # test commands taken from
  # https://github.com/TileDB-Inc/TileDB/blob/dev/.github/workflows/unit-test-runs.yml
  checkPhase = ''
    runHook preCheck
    make -C tiledb tests -j$NIX_BUILD_CORES
    make -C tiledb test ARGS="-R '^unit_'" -R "test_assert"
    make -C tiledb test ARGS="-R 'test_ci_asserts'"
    runHook postCheck
  '';

  doCheck = true;

  installTargets = [
    "install-tiledb"
    "doc"
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath ${tbb}/lib $out/lib/libtiledb.dylib
  '';

  meta = with lib; {
    description = "TileDB allows you to manage the massive dense and sparse multi-dimensional array data";
    homepage = "https://github.com/TileDB-Inc/TileDB";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
