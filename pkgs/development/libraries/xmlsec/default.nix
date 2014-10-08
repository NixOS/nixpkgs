{ stdenv, fetchurl, libxml2, gnutls, libxslt, pkgconfig, libgcrypt, libtool }:

let
  version = "1.2.20";
in
stdenv.mkDerivation rec {
  name = "xmlsec-${version}";

  src = fetchurl {
    url = "http://www.aleksey.com/xmlsec/download/xmlsec1-${version}.tar.gz";
    sha256 = "01bkbv2y3x8d1sf4dcln1x3y2jyj391s3208d9a2ndhglly5j89j";
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
