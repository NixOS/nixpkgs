args:
args.stdenv.mkDerivation {
  name = "goocanvas-0.10";

  src = args.fetchurl {
    url = mirror://sourceforge/goocanvas/goocanvas-0.10.tar.gz;
    sha256 = "0b49szbr3n7vpavly9w17ipa8q3ydicdcd177vxbdvbsnvg7aqp9";
  };

  buildInputs =(with args; [gtk cairo glib pkgconfig]);

  meta = { 
      description = "canvas widget for GTK+ using the cairo 2D library";
      homepage = http://goocanvas.sourceforge.net/;
      license = ["GPL" "LGPL"];
  };
}
