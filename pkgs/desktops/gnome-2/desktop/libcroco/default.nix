{stdenv, fetchurl, pkgconfig, libxml2, glib}:

stdenv.mkDerivation {
  name = "libcroco-0.6.2";
  src = fetchurl {
    url = mirror://gnome/sources/libcroco/0.6/libcroco-0.6.2.tar.bz2;
    sha256 = "0j8p6xlpdhhbzjznr7rx7jiy3fi95qib0gsnkv9n76y0chzqa95y";
  };
  buildInputs = [ pkgconfig libxml2 glib ];
}
