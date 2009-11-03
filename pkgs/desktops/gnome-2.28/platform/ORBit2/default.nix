{stdenv, fetchurl, pkgconfig, glib, libIDL}:

stdenv.mkDerivation {
  name = "ORBit2-2.14.17";
  
  src = fetchurl {
    url = mirror://gnome/sources/ORBit2/2.14/ORBit2-2.14.17.tar.bz2;
    sha256 = "0k4px2f949ac7vmj7b155g1rpf7pmvl48sbnkjhlg4wgcwzwxgv2";
  };
  
  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libIDL ];
}
