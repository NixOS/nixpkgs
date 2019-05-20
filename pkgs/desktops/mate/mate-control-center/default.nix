{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, dbus-glib,
  libxklavier, libcanberra-gtk3, librsvg, libappindicator-gtk3,
  desktop-file-utils, gnome3, gtk3, mate, hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "mate-control-center-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0w9w3wkxksbhzyd96y1x6yxb0q5lkp16y8i42564b6njvwqch5a0";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    dbus-glib
    libxklavier
    libcanberra-gtk3
    librsvg
    libappindicator-gtk3
    gtk3
    gnome3.dconf
    hicolor-icon-theme
    mate.mate-desktop
    mate.libmatekbd
    mate.mate-menus
    mate.marco
    mate.mate-settings-daemon
  ];

  patches = [
    # look up keyboard shortcuts in system data dirs
    ./mate-control-center.keybindings-dir.patch
  ];

  configureFlags = [ "--disable-update-mimedb" ];

  preFixup = ''
    gappsWrapperArgs+=(
      # WM keyboard shortcuts
      --prefix XDG_DATA_DIRS : "${mate.marco}/share"
    )
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Utilities to configure the MATE desktop";
    homepage = https://github.com/mate-desktop/mate-control-center;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
