{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsNoGuiHook
, cinnamon-desktop
, glib
, gsettings-desktop-schemas
, mate
, xdg-desktop-portal
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-xapp";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xdg-desktop-portal-xapp";
    rev = version;
    hash = "sha256-4U8d9lQxMHQ2XYXnNCQjrNup8z14Q8Ke1Bkf09AVM6k=";
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
    gsettings-desktop-schemas # org.gnome.system.location
    mate.mate-desktop # org.mate.background
    xdg-desktop-portal
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  meta = with lib; {
    description = "Backend implementation for xdg-desktop-portal for Cinnamon, MATE, Xfce";
    homepage = "https://github.com/linuxmint/xdg-desktop-portal-xapp";
    maintainers = teams.cinnamon.members;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
