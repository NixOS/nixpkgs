{stdenv, fetchurl, pkgconfig, perl, libxml2, libglade, libgnome
, libgnomecanvas}:

assert pkgconfig != null && perl != null && libxml2 != null
  && libglade != null && libgnome != null && libgnomecanvas != null;

stdenv.mkDerivation {
  name = "libbonoboui-2.4.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libbonoboui-2.4.1.tar.bz2;
    md5 = "943a2d0e9fc7b9f0e97ba869de0c5f2a";
  };
  buildInputs = [pkgconfig perl libglade];
  propagatedBuildInputs = [libxml2 libgnome libgnomecanvas];
}
