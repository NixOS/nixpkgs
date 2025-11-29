{
  alsa-lib,
  cmake,
  dbus,
  fetchFromGitHub,
  glib,
  gst_all_1,
  lib,
  mpv-unwrapped,
  openssl,
  pkg-config,
  protobuf,
  rustPlatform,
  sqlite,
  libopus,
  stdenv,
  withOpus ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";
    rev = "v${version}";
    hash = "sha256-nlQEEwQTmjMB4T8g9E7tHs+I8vnJ0JCx4vglael5bOw=";
  };

  cargoHash = "sha256-lOp5H7m1ZZepkmbbQ7zAjd5cBtOlmuSAl1zQRtGWWj0=";

  useNextest = true;

  buildFeatures = lib.optional withOpus [ "rusty-libopus" ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals withOpus [
    cmake
  ];

  buildInputs = [
    dbus
    glib
    gst_all_1.gstreamer
    mpv-unwrapped
    openssl
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals withOpus [
    libopus
  ];

  meta = {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [
      devhell
      theeasternfurry
    ];
    mainProgram = "termusic";
  };
}
