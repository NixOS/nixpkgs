{
  lib,
  stdenv,
  fetchFromGitea,
  rustPlatform,

  # nativeBuildInputs
  cargo,
  desktop-file-utils,
  gettext,
  meson,
  ninja,
  pkg-config,
  python3,
  rustc,
  wrapGAppsHook4,

  # buildInputs
  gdk-pixbuf,
  graphene,
  gtk4,
  gtksourceview5,
  libadwaita,
  libspelling,
  openssl,
  pango,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "typesetter";
  version = "0.6.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "haydn";
    repo = "typesetter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZbMg7yKJ9nYVqDfPO614PhEoL8fmVbdHONfWgCbZZ0k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ZCWMyxzku5FXWF7EkeQ6O9qbZs1MBzuSIw2g198DNt0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    gettext # msgfmt
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    graphene
    gtk4
    gtksourceview5
    libadwaita
    libspelling
    openssl
    pango
  ];

  env.OPENSSL_NO_VENDOR = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalist, local-first Typst editor";
    homepage = "https://codeberg.org/haydn/typesetter";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "typesetter";
  };
})
