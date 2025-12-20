{
  alsa-lib,
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
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";
    rev = "v${version}";
    hash = "sha256-e+D7ykqGX2UprakCZc9Gmaxct+b19DMfTRMkeIANXqg=";
  };

  cargoHash = "sha256-0JVKY3A3W3vJgDtlZE6gtrXQa2e+4YA6R6mFUYhuQkk=";

  useNextest = true;

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
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
  ];

  meta = {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ devhell ];
    mainProgram = "termusic";
  };
}
