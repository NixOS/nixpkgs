{input, stdenv, fetchurl, pkgconfig, libgnome, libgnomecanvas,
libbonoboui, libglade, esound, libjpeg, gnomekeyring}:

assert pkgconfig != null && libgnome != null && libgnomecanvas != null
  && libbonoboui != null && libglade != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig libglade esound libjpeg];
  propagatedBuildInputs = [libgnome libgnomecanvas libbonoboui libjpeg gnomekeyring];
}
