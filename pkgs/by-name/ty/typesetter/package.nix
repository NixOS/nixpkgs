{
  lib,
  stdenv,
  fetchFromCodeberg,
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
  shared-mime-info,
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
  version = "0.15.2";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "haydn";
    repo = "typesetter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ck7kW2dVBvl0zbXurTXaxQetWZ57mVSmVl1mE3zg2YE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-n50EBOcwrbFPQAxfxK3fQWPSp/g6DRIbETOlS+ooWgo=";
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
    shared-mime-info # update-mime-database
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "typesetter";
  };
})
