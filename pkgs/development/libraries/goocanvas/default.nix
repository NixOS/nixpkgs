{ stdenv, fetchurl, gtk, cairo, glib, pkgconfig }:

stdenv.mkDerivation {
  name = "goocanvas-0.10";

  src = fetchurl {
    url = mirror://sourceforge/goocanvas/goocanvas-0.10.tar.gz;
    sha256 = "0b49szbr3n7vpavly9w17ipa8q3ydicdcd177vxbdvbsnvg7aqp9";
  };

  buildInputs = [ gtk cairo glib pkgconfig ];

  meta = { 
    description = "Canvas widget for GTK+ based on the the Cairo 2D library";
    homepage = http://goocanvas.sourceforge.net/;
    license = ["GPL" "LGPL"];
  };
}
