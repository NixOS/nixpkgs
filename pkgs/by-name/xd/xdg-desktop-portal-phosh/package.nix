{
  stdenv,
  lib,
  fetchFromGitLab,
  gnome-desktop,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  xdg-desktop-portal,
  rustc,
  desktop-file-utils,
  cargo,
  docutils,
  glib,
  rustPlatform,
  gettext,
}:
let
  # Derived from subprojects/pfs.wrap
  pfs = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "pfs";
    tag = "v0.1.0";
    hash = "sha256-u0Ac3DJ0FaawlRNQwPp6tVKJkUaFHH/r1T0QRa4bIaU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-phosh";
  version = "0.55.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "xdg-desktop-portal-phosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oHjBuQ9kD1RnBKSi+w3xxYBPrByzqsmKVOMIoHepoyQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-cPuyI0PtdbAgbZ3ZCTRIBcjNROVi0wCHSfST+kzJSd4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    desktop-file-utils
    cargo
    docutils
    rustPlatform.cargoSetupHook
    gettext
    glib
  ];

  buildInputs = [
    libadwaita
    gnome-desktop
    xdg-desktop-portal
  ];

  strictDeps = true;

  prePatch = ''
    cp -r ${pfs} subprojects/pfs
    chmod +w -R subprojects/pfs # Allow patches for subprojects to work
    # xdg-desktop-portal-phosh's Cargo.lock closes over pfs and its dependencies,
    # making pfs's own lockfile extraneous.
    rm subprojects/pfs/Cargo.lock
  '';

  meta = {
    description = "A backend implementation for xdg-desktop-portal that is using GTK/GNOME/Phosh to provide interfaces that aren't provided by the GTK portal";
    homepage = "https://gitlab.gnome.org/World/Phosh/xdg-desktop-portal-phosh";
    changelog = "https://gitlab.gnome.org/World/Phosh/xdg-desktop-portal-phosh/-/blob/main/NEWS";
    maintainers = with lib.maintainers; [ armelclo ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
})
