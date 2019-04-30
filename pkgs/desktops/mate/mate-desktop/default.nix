{ stdenv, fetchurl, pkgconfig, intltool, isocodes, gnome3, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-desktop-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1hr4r69855csqrcaqpbcyplsy4cwjfz7gabps2pzkh5132jycfr0";
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
