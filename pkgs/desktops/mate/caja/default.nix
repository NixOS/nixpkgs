{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libnotify, libxml2, libexif, exempi, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "caja-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1fc7dxj9hw8fffrcnwxbj8pq7gl08il68rkpk92rv3qm7siv1606";
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
  ];

  configureFlags = [ "--disable-update-mimedb" ];
  
  meta = {
    description = "File manager for the MATE desktop";
    homepage = "http://mate-desktop.org";
    license = with stdenv.lib.licenses; [ gpl2 lgpl2 ];
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
