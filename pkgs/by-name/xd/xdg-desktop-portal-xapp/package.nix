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
  xdg-desktop-portal,
  xapp,
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-xapp";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xdg-desktop-portal-xapp";
    rev = version;
    hash = "sha256-3EGim8GDlzVhgKiBHaOjV+apyEanFyfTqfJLegwlQHo=";
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
    xdg-desktop-portal
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  preFixup = ''
    # For xfce4-set-wallpaper
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ xapp ]}")
  '';

  meta = with lib; {
    description = "Backend implementation for xdg-desktop-portal for Cinnamon, MATE, Xfce";
    homepage = "https://github.com/linuxmint/xdg-desktop-portal-xapp";
    teams = [ teams.cinnamon ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
