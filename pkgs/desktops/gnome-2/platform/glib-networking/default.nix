{stdenv, fetchurl, pkgconfig, glib, libtool, intltool, gnutls2, libproxy
  , libgcrypt, libtasn1
  }:

stdenv.mkDerivation {
  name = "glib-networking-2.28.5";
  
  src = fetchurl {
    url = mirror://gnome/sources/glib-networking/2.28/glib-networking-2.28.5.tar.bz2;
    sha256 = "959ffeb91fee17c1b0fb2aa82872c3daae0230de93708b2ebabeb92b747d7876";
  };

  configureFlags = [
    "--without-ca-certificates"
  ];
  
  preBuild = ''
    sed -e "s@${glib}/lib/gio/modules@$out/lib/gio/modules@g" -i $(find . -name Makefile)
  '';

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libtool intltool gnutls2 libproxy libgcrypt 
    libtasn1];
}
