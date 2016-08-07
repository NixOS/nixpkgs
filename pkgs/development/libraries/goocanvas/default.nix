{ stdenv, fetchurl, gtk, cairo, glib, pkgconfig }:

stdenv.mkDerivation rec {
  majVersion = "1.0";
  version = "${majVersion}.0";
  name = "goocanvas-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/goocanvas/${majVersion}/${name}.tar.bz2";
    sha256 = "07kicpcacbqm3inp7zq32ldp95mxx4kfxpaazd0x5jk7hpw2w1qw";
  };

  buildInputs = [ gtk cairo glib pkgconfig ];

  meta = { 
    description = "Canvas widget for GTK+ based on the the Cairo 2D library";
    homepage = http://goocanvas.sourceforge.net/;
    license = ["GPL" "LGPL"];
    platforms = stdenv.lib.platforms.unix;
  };
}
