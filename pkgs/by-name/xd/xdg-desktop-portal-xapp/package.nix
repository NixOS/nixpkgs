{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsNoGuiHook,
  cinnamon-desktop,
  glib,
  gtk3,
  gsettings-desktop-schemas,
  mate,
  xapp,
  xdg-desktop-portal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-xapp";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xdg-desktop-portal-xapp";
    rev = finalAttrs.version;
    hash = "sha256-5gJmWj15jUVGhCf8jOl/eXHVisFdegbbx6pqz6btNTM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    cinnamon-desktop # org.cinnamon.desktop.background
    glib
    gtk3
    gsettings-desktop-schemas # org.gnome.system.location
    mate.mate-desktop # org.mate.background
    xapp # org.x.apps.portal
    xdg-desktop-portal
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  preFixup = ''
    # For xfce4-set-wallpaper
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ xapp ]}")
  '';

  meta = {
    description = "Backend implementation for xdg-desktop-portal for Cinnamon, MATE, Xfce";
    homepage = "https://github.com/linuxmint/xdg-desktop-portal-xapp";
    teams = [ lib.teams.cinnamon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Plus;
  };
})
