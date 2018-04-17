{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libnotify, libxml2, libexif, exempi, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "caja-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1qqqq3fi1aqjqg36y3v73z4d0bqkx7d5f79i6h9lxyh3s0876v9c";
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
    homepage = http://mate-desktop.org;
    license = with stdenv.lib.licenses; [ gpl2 lgpl2 ];
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
