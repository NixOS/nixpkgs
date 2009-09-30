{stdenv, fetchurl, pkgconfig, libX11, gtk, intltool}:

stdenv.mkDerivation {
  name = "libwnck-2.28.0";
  src = fetchurl {
    url = mirror://gnome/sources/libwnck/2.28/libwnck-2.28.0.tar.bz2;
    sha256 = "0ixr2sffbcm6gn29vmli7x30cfi1848w8vgdhy93m8zg5xny62yr";
  };
  buildInputs = [ pkgconfig libX11 gtk intltool ];
}
