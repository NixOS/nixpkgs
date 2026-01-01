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
<<<<<<< HEAD
  version = "0.12.1";
=======
  version = "0.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-e+D7ykqGX2UprakCZc9Gmaxct+b19DMfTRMkeIANXqg=";
  };

  cargoHash = "sha256-0JVKY3A3W3vJgDtlZE6gtrXQa2e+4YA6R6mFUYhuQkk=";
=======
    hash = "sha256-nlQEEwQTmjMB4T8g9E7tHs+I8vnJ0JCx4vglael5bOw=";
  };

  cargoHash = "sha256-lOp5H7m1ZZepkmbbQ7zAjd5cBtOlmuSAl1zQRtGWWj0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
