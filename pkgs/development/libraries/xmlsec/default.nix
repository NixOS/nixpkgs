{ stdenv, fetchurl, libxml2, gnutls, libxslt, pkgconfig, libgcrypt, libtool }:

let
  version = "1.2.19";
in
stdenv.mkDerivation rec {
  name = "xmlsec-${version}";

  src = fetchurl {
    url = "http://www.aleksey.com/xmlsec/download/xmlsec1-${version}.tar.gz";
    sha256 = "1h5ar0h8n0l8isgic82w00cwfpw7i9wxw17kbdb6q3yvzb4zgj1g";
  };

  buildInputs = [ libxml2 gnutls libxslt pkgconfig libgcrypt libtool ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.aleksey.com/xmlsec;
    description = "XML Security Library in C based on libxml2";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
