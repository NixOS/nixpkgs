{ lib, stdenv, fetchurl, pkg-config, intltool, gtk2 }:

stdenv.mkDerivation rec {
  pname = "gtk-engine-bluecurve";
  version = "1.0";

  src = fetchurl {
    url = "https://ftp.gnome.org/pub/gnome/teams/art.gnome.org/archive/themes/gtk2/GTK2-Wonderland-Engine-${version}.tar.bz2";
    sha256 = "1nim3lhmbs5mw1hh76d9258c1p923854x2j6i30gmny812c7qjnm";
  };

  nativeBuildInputs = [ pkg-config intltool ];

  buildInputs = [ gtk2 ];

  meta = {
    description = "Original Bluecurve engine from Red Hat's artwork package";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
