<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, zlib
, zstd
, icu
, cyrus_sasl
, snappy
, darwin
}:

stdenv.mkDerivation rec {
  pname = "mongoc";
  version = "1.24.3";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-zEIdK994aebLeKe4g6/ByWvaoGNBB0ODXRpczrCEkB8=";
  };

  postPatch = ''
    substituteInPlace src/libbson/CMakeLists.txt src/libmongoc/CMakeLists.txt \
      --replace "\\\''${prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
    zstd
    icu
    cyrus_sasl
    snappy
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
  ];

  cmakeFlags = [
    "-DBUILD_VERSION=${version}"
    "-DENABLE_UNINSTALL=OFF"
    "-DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    rm -rf src/{libmongoc,libbson}
  '';

  meta = with lib; {
=======
{
  lib,
  stdenv,
  fetchzip,
  cmake,
  pkg-config,
  perl,
  openssl,
  zlib,
  cyrus_sasl,
  libbson,
  snappy,
  darwin,
}:
let
  inherit (darwin.apple_sdk.frameworks) Security;
in
stdenv.mkDerivation rec {
  pname = "mongoc";
  version = "1.23.3";

  src = fetchzip {
    url = "https://github.com/mongodb/mongo-c-driver/releases/download/${version}/mongo-c-driver-${version}.tar.gz";
    sha256 = "sha256-wxcBnJENL3hMzf7GKLucjw7K08tK35+0sMNWZb2mWIo=";
  };

  # https://github.com/NixOS/nixpkgs/issues/25585
  preFixup = ''rm -rf "$(pwd)" '';
  # https://github.com/mongodb/mongo-c-driver/pull/1157
  # related:
  # https://github.com/NixOS/nixpkgs/issues/144170
  # mongoc's cmake incorrectly injects a prefix to library paths, breaking Nix. This removes the prefix from paths.
  postPatch = ''
    substituteInPlace src/libmongoc/CMakeLists.txt \
      --replace "\\\''${prefix}/" ""
    substituteInPlace src/libbson/CMakeLists.txt \
      --replace "\\\''${prefix}/" ""
  '';

  nativeBuildInputs = [cmake pkg-config perl];
  buildInputs = [openssl zlib cyrus_sasl] ++ lib.optionals stdenv.isDarwin [Security];
  propagatedBuildInputs = [libbson snappy];

  # -DMONGOC_TEST_USE_CRYPT_SHARED=OFF
  # The `mongodl.py` script is causing issues, and you also need to disabled sandboxing for it. However, it is used only to run some tests.
  # https://www.mongodb.com/community/forums/t/problem-downloading-crypt-shared-when-installing-the-mongodb-c-driver/189370
  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release" "-DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF" "-DMONGOC_TEST_USE_CRYPT_SHARED=OFF"];

  enableParallelBuilding = true;

  meta = with lib; {
    broken = stdenv.isDarwin && stdenv.isx86_64;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "The official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = licenses.asl20;
    mainProgram = "mongoc-stat";
<<<<<<< HEAD
    maintainers = with maintainers; [ archer-65 ];
=======
    maintainers = with maintainers; [archer-65];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
  };
}
