{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, libgtop, libcanberra-gtk3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-utils-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0q05zzxgwwk7af05yzcjixjd8hi8cqykirj43g60ikhzym009n4q";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libgtop
    libcanberra-gtk3
    libxml2
    mate.mate-panel
    hicolor-icon-theme
  ];

  meta = with stdenv.lib; {
    description = "Utilities for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
