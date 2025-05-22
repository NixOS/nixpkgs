{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  appstream-glib,
  openssl,
  libadwaita,
  libpanel,
  gtksourceview5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "typewriter";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "JanGernert";
    repo = "typewriter";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-c4wh59RNYMyK1rwoxzjhDCtnGnAxGABAu5cugV3P0zU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-YvzVpSAPORxjvbGQqRK1V8DKcF12NUOGOgmegJSODQc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    appstream-glib
  ];

  buildInputs = [
    openssl
    libadwaita
    libpanel
    gtksourceview5
  ];

  meta = {
    mainProgram = "typewriter";
    description = "Create documents with typst";
    homepage = "https://gitlab.gnome.org/JanGernert/typewriter";
    changelog = "https://gitlab.gnome.org/JanGernert/typewriter/-/releases/v.${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.awwpotato ];
  };
})
