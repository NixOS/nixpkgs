{ lib, stdenv, fetchurl, pkg-config, gettext, itstool, libxml2, dbus-glib
, libxklavier, libcanberra-gtk3, librsvg, libappindicator-gtk3
, desktop-file-utils, dconf, gtk3, polkit, mate, hicolor-icon-theme, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-control-center";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "18vsqkcl4n3k5aa05fqha61jc3133zw07gd604sm0krslwrwdn39";
  };

  nativeBuildInputs = [
    pkg-config
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

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Utilities to configure the MATE desktop";
    homepage = "https://github.com/mate-desktop/mate-control-center";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
