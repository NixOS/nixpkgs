{ stdenv, fetchurl
, pkgconfig
, gtk3, glib, glibmm, gtkmm3, gtkspell3
}:

stdenv.mkDerivation rec {
  pname = "gtkspellmm";
  version = "3.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/gtkspell/gtkspellmm/" +
          "${pname}-${version}.tar.xz";
    sha256 = "0i8mxwyfv5mskachafa4qlh315q0cfph7s66s1s34nffadbmm1sv";
  };

  propagatedBuildInputs = [
    gtkspell3
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 glib glibmm gtkmm3
  ];

  meta = with stdenv.lib; {
    description = "C++ binding for the gtkspell library";
    homepage = http://gtkspell.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
