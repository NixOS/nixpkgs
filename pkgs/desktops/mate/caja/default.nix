{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libnotify, libxml2, libexif, exempi, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "caja";
  version = "1.22.3";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1w2liq9h1kr5zyaaq82xz8pic04qi5sra8kaycfg1iddmknkfqn7";
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
