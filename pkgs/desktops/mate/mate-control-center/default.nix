{ stdenv, fetchurl, pkgconfig, gettext, itstool, libxml2, dbus-glib,
  libxklavier, libcanberra-gtk3, librsvg, libappindicator-gtk3,
  desktop-file-utils, dconf, gtk3, polkit, mate, hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "mate-control-center";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "08bai47fsmbxlw2lhig9n6c8sxr24ixkd1spq3j0635yzcqighb0";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
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
    dconf
    polkit
    hicolor-icon-theme
    mate.mate-desktop
    mate.libmatekbd
    mate.mate-menus
    mate.marco
    mate.mate-settings-daemon
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
    homepage = "https://github.com/mate-desktop/mate-control-center";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
