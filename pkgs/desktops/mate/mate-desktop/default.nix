{ stdenv, fetchurl, pkgconfig, intltool, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-desktop-${version}";
  version = "1.20.3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "132z1wwmh5115cpgkx9w6hzkk87f1vh66paaf3b2d2qfci7myffs";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.dconf
    gnome3.gtk
  ];

  meta = with stdenv.lib; {
    description = "Library with common API for various MATE modules";
    homepage = http://mate-desktop.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
