{ stdenv, fetchurl, pkgconfig, intltool, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-desktop-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "12iv2y4dan962fs7vkkxbjkp77pbvjnwfa43ggr0zkdsc3ydjbbg";
  };

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
  ];

  buildInputs = [
    gnome3.dconf
    gnome3.gtk
    gnome3.defaultIconTheme
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  meta = with stdenv.lib; {
    description = "Library with common API for various MATE modules";
    homepage = "http://mate-desktop.org";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
