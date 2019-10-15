{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libnotify, libxml2, libexif, exempi, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "caja";
  version = "1.22.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1c5yr4b8pzd7nz7g7ln9jwp4fx6qgq8vgbv4spfryy53il3gv75h";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libnotify
    libxml2
    libexif
    exempi
    mate.mate-desktop
    hicolor-icon-theme
  ];

  patches = [
    ./caja-extension-dirs.patch
  ];

  configureFlags = [ "--disable-update-mimedb" ];

  meta = {
    description = "File manager for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = with stdenv.lib.licenses; [ gpl2 lgpl2 ];
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
