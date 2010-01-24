{stdenv, fetchurl, pkgconfig, gtk, gettext, libxml2 }:

stdenv.mkDerivation {
  name = "libgtkhtml-2.11.1";
  
  src = fetchurl {
    url = mirror://gnome/sources/libgtkhtml/2.11/libgtkhtml-2.11.1.tar.bz2;
    sha256 = "0msajafd42545dxzyr5zqka990cjrxw2yz09ajv4zs8m1w6pm9rw";
  };
  
  buildInputs = [ pkgconfig gtk gettext ];
  propagatedBuildInputs = [ libxml2 ];
}
