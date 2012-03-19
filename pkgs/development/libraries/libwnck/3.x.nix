{stdenv, fetchurl, pkgconfig, libX11, gtk3, intltool}:

stdenv.mkDerivation {
  name = "libwnck-3.2.1";

  src = fetchurl {
    url = mirror://gnome/sources/libwnck/3.2/libwnck-3.2.1.tar.xz;
    sha256 = "1nm34rpr0n559x1ba4kmxbhqclvvnlz0g8xqbbj709q9irnmifpa";
  };

  buildInputs = [ pkgconfig intltool ];
  propagatedBuildInputs = [ libX11 gtk3 ];
}
