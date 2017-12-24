{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libnotify, libxml2, libexif, exempi, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "caja-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "5";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1ild2bslvnvxvl5q2xc1sa8bz1lyr4q4ksw3bwxrj0ymc16h7p50";
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
