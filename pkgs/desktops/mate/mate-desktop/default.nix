{ stdenv, fetchurl, pkgconfig, intltool, isocodes, gnome3, gtk3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-desktop-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "09gn840p6qds21kxab4pidjd53g76s76i7178fdibrz462mda217";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.dconf
    gtk3
    isocodes
  ];

  meta = with stdenv.lib; {
    description = "Library with common API for various MATE modules";
    homepage = https://mate-desktop.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
