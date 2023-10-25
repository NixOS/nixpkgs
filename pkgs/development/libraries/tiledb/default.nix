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
, clang-tools
, catch2
, python3
, gtest
, doxygen
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "tiledb";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB";
    rev = version;
    hash = "sha256-HKMVwrPnk9/mukH3mJ2LEAvA9LBF4PcgBZjbbLhO9qU=";
  };

  # (bundled) blosc headers have a warning on some archs that it will be using
  # unaccelerated routines.
  cmakeFlags = [
    "-DTILEDB_WERROR=0"
  ];

  nativeBuildInputs = [
    clang-tools
    cmake
    python3
    doxygen
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
  ];

  # emulate the process of pulling catch down
  postPatch = ''
    mkdir -p build/externals/src/ep_catch
    ln -sf ${catch2}/include/catch2 build/externals/src/ep_catch/single_include
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
