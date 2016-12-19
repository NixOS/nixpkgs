{ stdenv, fetchurl
, pkgconfig
, gtk3, glib, glibmm, gtkmm3, gtkspell3
}:

let
  version = "3.0.4";

in

stdenv.mkDerivation rec {
  name = "gtkspellmm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/gtkspell/gtkspellmm/" +
          "${name}.tar.gz";
    sha256 = "0x6zx928dl62f0c0x6b2s32i06lvn18wx7crrgs1j9yjgkim4k4k";
  };

  propagatedBuildInputs = [
    gtkspell3
  ];

  buildInputs = [
    pkgconfig
    gtk3 glib glibmm gtkmm3
  ];

  meta = with stdenv.lib; {
    description = "C++ binding for the gtkspell library";
    homepage = http://gtkspell.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
