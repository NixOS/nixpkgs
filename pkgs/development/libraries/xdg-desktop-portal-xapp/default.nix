{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, cinnamon
, glib
, gsettings-desktop-schemas
, gtk3
, mate
, xdg-desktop-portal
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-xapp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xdg-desktop-portal-xapp";
    rev = version;
    hash = "sha256-oXV4u/w4MWhKHf5vNbUNcyEJpKVFWcyEs1HEqo6eCyU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    cinnamon.cinnamon-desktop # org.cinnamon.desktop.background
    glib
    gsettings-desktop-schemas # org.gnome.system.location
    gtk3
    mate.mate-desktop # org.mate.background
    xdg-desktop-portal
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  postPatch = ''
    chmod +x data/meson_install_schemas.py
    patchShebangs data/meson_install_schemas.py
  '';

  meta = with lib; {
    description = "Backend implementation for xdg-desktop-portal for Cinnamon, MATE, Xfce";
    homepage = "https://github.com/linuxmint/xdg-desktop-portal-xapp";
    maintainers = teams.cinnamon.members;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
