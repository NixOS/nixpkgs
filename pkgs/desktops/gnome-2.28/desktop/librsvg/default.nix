{stdenv, fetchurl, pkgconfig, libxml2, libgsf, bzip2, glib, gtk, libcroco}:

stdenv.mkDerivation {
  name = "librsvg-2.26.0";
  src = fetchurl {
    url = mirror://gnome/sources/librsvg/2.26/librsvg-2.26.0.tar.bz2;
    sha256 = "1sivagvlyr58hxgazr6pyq3yfxbg0wrv7rgzsk5xi631v3qbbjpx";
  };
  buildInputs = [ pkgconfig libxml2 libgsf bzip2 glib gtk libcroco ];
}
