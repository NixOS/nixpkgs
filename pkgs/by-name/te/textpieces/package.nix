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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textpieces";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "liferooter";
    repo = "textpieces";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JFHDPzVRD3HZI9+TBCe92xTcuIPAF/iD8hIiYPgetLc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-SMNyPo0y8376wjuZVyu3jMjfPgddEMrqCPvUzsYa0xc=";
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

  passthru = {
    updateScript = nix-update-script { };
  };

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
    ];
    teams = [ lib.teams.gnome-circle ];
  };
})
