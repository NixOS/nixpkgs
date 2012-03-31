{stdenv, fetchurl, pkgconfig, glib, libtool, intltool, gnutls2, libproxy
, gsettings_desktop_schemas, libgcrypt, libtasn1 }:

stdenv.mkDerivation {
  name = "glib-networking-2.30.2";

  src = fetchurl {
    url = mirror://gnome/sources/glib-networking/2.30/glib-networking-2.30.2.tar.xz;
    sha256 = "1g2ran0rn37009fs3xl38m95i5w8sdf9ax0ady4jbjir15844xcz";
  };

  configureFlags = "--with-ca-certificates=/etc/ca-bundle.crt";
  
  preBuild = ''
    sed -e "s@${glib}/lib/gio/modules@$out/lib/gio/modules@g" -i $(find . -name Makefile)
  '';

  buildNativeInputs = [ pkgconfig intltool ];
  propagatedBuildInputs =
    [ glib libtool gnutls2 libproxy libgcrypt libtasn1 gsettings_desktop_schemas ];
}
