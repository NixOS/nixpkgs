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
  version = "0.16.5";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "haydn";
    repo = "typesetter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fEjA8BlVsjqj9Nng9nCfmPtN3B1E+SOS6wMxbyaTEIY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-arLIL1ftluVpGNI4owAHMXmcNDHMb9IxZTmlrGESn3A=";
  };

  # Upstream does not install desktop/MIME files on darwin, so the corresponding post-install hooks
  # fail there
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace meson.build \
      --replace-fail \
        "update_desktop_database: true" \
        "update_desktop_database: false" \
      --replace-fail \
        "update_mime_database: true" \
        "update_mime_database: false"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cargo
    gettext # msgfmt
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    shared-mime-info # update-mime-database
    wrapGAppsHook4
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Needed to install the desktop file on Linux
    desktop-file-utils
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
