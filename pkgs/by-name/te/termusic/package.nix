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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termusic";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GAbUvxRWKy5tDjf+G5cKXgwNs9Rm52h7mICyDFlrCoo=";
  };

  cargoHash = "sha256-xFQObWhONoRBAdEZblBDQeQtq/KmaCWWnCwv3XEmG2k=";

  useNextest = true;

  buildFeatures = [ "rusty-libopus" ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    cmake
  ];

  buildInputs = [
    dbus
    glib
    gst_all_1.gstreamer
    mpv-unwrapped
    openssl
    sqlite
    libopus
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
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
})
