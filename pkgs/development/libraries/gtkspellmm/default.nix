{ stdenv, fetchurl
, pkgconfig
, gtk3, glib, glibmm, gtkmm3, gtkspell3
}:

let
  version = "3.0.3";

in

stdenv.mkDerivation rec {
  name = "gtkspellmm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/gtkspell/gtkspellmm/" +
          "${name}.tar.gz";
    sha256 = "f9dcc0991621c08e7a972f33487afd6b37491468f0b654f50c741a7e6d810624";
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
