{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, cargo
, rustc
, rustPlatform
, blueprint-compiler
, glib
, gtk4
, libadwaita
, gtksourceview5
, wrapGAppsHook4
, desktop-file-utils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textpieces";
  version = "4.0.6";

  src = fetchFromGitLab {
    owner = "liferooter";
    repo = "textpieces";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6kbGvCiaoOY+pwSmaDn1N/rbTBzEehNi/j+RI05nn6o=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "textpieces-core-1.0.0" = "sha256-HaLkL2HhH1khwsSdH64pZYtJ/WG+MLiEQPScDte/PAg=";
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
    longDescription = "A small tool for quick text transformations such as checksums, encoding, decoding and so on.";
    homepage = "https://gitlab.com/liferooter/textpieces";
    mainProgram = "textpieces";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
