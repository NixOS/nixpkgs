{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, dbus-glib,
  libxklavier, libcanberra-gtk3, librsvg, libappindicator-gtk3,
  desktop-file-utils, dconf, gtk3, mate, hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "mate-control-center";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1ybdjibi6wgqn3587a66ckxp2qkvl4mcvv2smhflyxksl5djrjgh";
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
    dconf
    hicolor-icon-theme
    mate.mate-desktop
    mate.libmatekbd
    mate.mate-menus
    mate.marco
    mate.mate-settings-daemon
  ];

  patches = [
    # see https://github.com/mate-desktop/mate-control-center/pull/528
    ./0001-Search-system-themes-in-system-data-dirs.patch
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
