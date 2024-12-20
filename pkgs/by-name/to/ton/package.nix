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
  darwinMinVersionHook,
  apple-sdk_11,
}:

stdenv.mkDerivation rec {
  pname = "ton";
  version = "2024.10";

  src = fetchFromGitHub {
    owner = "ton-blockchain";
    repo = "ton";
    rev = "v${version}";
    hash = "sha256-Eab5tXP5gv9v/hu/Eh2WC/SeJ/bG1u6FKbREKB/ry9c=";
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
  ];

  buildInputs =
    [
      gperf
      libmicrohttpd
      libsodium
      lz4
      openssl
      readline
      secp256k1
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # error: aligned allocation function of type 'void *(std::size_t, std::align_val_t)' is only available on macOS 10.13 or newer
      (darwinMinVersionHook "10.13")
      apple-sdk_11
    ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Fully decentralized layer-1 blockchain designed by Telegram";
    homepage = "https://ton.org/";
    changelog = "https://github.com/ton-blockchain/ton/blob/v${version}/Changelog.md";
    license = licenses.lgpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
