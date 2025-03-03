{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
  pkg-config,
  gperf,
  libmicrohttpd,
  libsodium,
  lz4,
  openssl,
  readline,
  secp256k1,
  zlib,
  nix-update-script,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "ton";
  version = "2025.03";

  src = fetchFromGitHub {
    owner = "ton-blockchain";
    repo = "ton";
    tag = "v${version}";
    hash = "sha256-iqAX/DlNprWosCx40KkbldwZWSwX6RI59ElOhOMNuCI=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    autoconf
    automake
  ];

  buildInputs = [
    gperf
    libmicrohttpd
    libsodium
    lz4
    openssl
    readline
    secp256k1
    zlib
    libtool
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fully decentralized layer-1 blockchain designed by Telegram";
    homepage = "https://ton.org/";
    changelog = "https://github.com/ton-blockchain/ton/blob/v${version}/Changelog.md";
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ misuzu ];
  };
}
