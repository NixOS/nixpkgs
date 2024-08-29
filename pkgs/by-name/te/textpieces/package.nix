{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  rustPlatform,
  blueprint-compiler,
  glib,
  gtk4,
  libadwaita,
  gtksourceview5,
  wrapGAppsHook4,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textpieces";
  version = "4.1.0";

  src = fetchFromGitLab {
    owner = "liferooter";
    repo = "textpieces";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0bc2Q3k08ZItRH7teQCv7uQyj4Rig6LtZmO5Vu48vxo=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "textpieces-core-1.1.2" = "sha256-fAATzugZ4kpUqHx8H4yuNH9Weeubkp8eAHAe94rMBmA=";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gtksourceview5
  ];

  meta = {
    description = "Swiss knife of text processing";
    longDescription = ''
      A small tool for quick text transformations such as
      checksums, encoding, decoding and so on.
    '';
    homepage = "https://gitlab.com/liferooter/textpieces";
    mainProgram = "textpieces";
    license = with lib.licenses; [
      gpl3Plus
      # and
      cc0
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      zendo
      aleksana
    ];
  };
})
