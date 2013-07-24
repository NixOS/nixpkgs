{ stdenv, fetchurl, pkgconfig, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "iksemel-${version}";
  version = "1.4";

  src = fetchurl {
    url = "https://iksemel.googlecode.com/files/${name}.tar.gz";
    sha1 = "722910b99ce794fd3f6f0e5f33fa804732cf46db";
  };

  preConfigure = ''
    sed -i -e '/if.*gnutls_check_version/,/return 1;/c return 0;' configure
    export LIBGNUTLS_CONFIG="${pkgconfig}/bin/pkg-config gnutls"
  '';

  buildInputs = [ pkgconfig gnutls zlib ];

  meta = {
    homepage = "https://code.google.com/p/iksemel/";
    license = stdenv.lib.licenses.lgpl21Plus;
    description = "Fast and portable XML parser and Jabber protocol library";
  };
}
