{ lib
, stdenv
, fetchFromGitHub
, cmake
, zlib
, lz4
, bzip2
, zstd
, spdlog
, tbb
, openssl
, boost
, libpqxx
, git
, clang-tools
, catch2
, python3
, gtest
, doxygen
, ninja
, curl
, zip
, unzip
, fixDarwinDylibNames
, useAVX2 ? stdenv.hostPlatform.avx2Support
}:

stdenv.mkDerivation rec {
  pname = "tiledb";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB";
    rev = version;
    hash = "sha256-2tSk1VFY+iIgzThZ7Ruy6xDpRZDn0sG3OJgaqqgDpGw=";
    fetchSubmodules = true;
  };

  # (bundled) blosc headers have a warning on some archs that it will be using
  # unaccelerated routines.
  cmakeFlags = [
    "-DTILEDB_WERROR=0"
    "-DCMAKE_MAKE_PROGRAM=ninja"
  ] ++ lib.optional (!useAVX2) "-DCOMPILER_SUPPORTS_AVX2=FALSE";

  nativeBuildInputs = [
    clang-tools
    cmake
    python3
    doxygen
    ninja
    curl
    zip
    unzip
  ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  nativeCheckInputs = [
    gtest
  ];

  buildInputs = [
    catch2
    zlib
    lz4
    bzip2
    zstd
    spdlog
    tbb
    openssl
    boost
    libpqxx
    git
  ];

  # emulate the process of pulling catch down
  postPatch = ''
    mkdir -p build/externals/src/ep_catch
    ln -sf ${catch2}/include/catch2 build/externals/src/ep_catch/single_include

    sed -i '38i list(APPEND OPENSSL_PATHS "${openssl.dev}" "${openssl.out}")' \
      cmake/Modules/FindOpenSSL_EP.cmake
  '';

  doCheck = true;

  installTargets = [ "install-tiledb" "doc" ];

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
