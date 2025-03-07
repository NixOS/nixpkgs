{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  fontconfig,
  glib,
  gnome-desktop,
  gsettings-desktop-schemas,
  gtk4,
  libadwaita,
  pfs,
  xdg-desktop-portal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-phosh";
  version = "0.44.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = "xdg-desktop-portal-phosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/V5ctHAuW4O+hnC0X6WEW53CI0pvLPpxuVOVavl0LSc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    glib
    gnome-desktop
    gsettings-desktop-schemas
    gtk4
    libadwaita
    pfs
    xdg-desktop-portal
  ];

  meta = {
    description = "Backend implementation for xdg-desktop-portal using GTK/GNOME/Phosh";
    homepage = "https://gitlab.gnome.org/guidog/xdg-desktop-portal-phosh";
    changelog = "https://gitlab.gnome.org/guidog/xdg-desktop-portal-phosh/-/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "xdg-desktop-portal-phosh";
    platforms = lib.platforms.linux;
  };
})
