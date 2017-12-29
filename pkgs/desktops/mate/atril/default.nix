{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libxml2, libsecret, poppler, itstool, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "atril-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.19";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0v829yvr738y5s2knyvimcgqv351qzb0rpw5il19qc27rbzyri1r";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    itstool
    libsecret
    libxml2
    poppler
    mate.mate-desktop
  ];

  configureFlags = [ "--disable-caja" ];
  
  meta = {
    description = "A simple multi-page document viewer for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
