{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python, glib, libxslt
, gtk3, intltool, gconf, libgnome_keyring, pango, gcr, gdk_pixbuf, atk, p11_kit
, docbook_xsl_ns, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "gnome-keyring-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/3.10/${name}.tar.xz";
    sha256 = "1y6v2p14jx5h6yh14c53pd8r0r5zbmcgw8v4nxvf94kd9jliy00q";
  };

  buildInputs = [
    dbus libgcrypt pam python gtk3 gconf libgnome_keyring
    pango gcr gdk_pixbuf atk p11_kit
  ];

  propagatedBuildInputs = [ glib libtasn1 libxslt ];

  nativeBuildInputs = [ pkgconfig intltool docbook_xsl_ns docbook_xsl ];

  configureFlags = [
    "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt" # NixOS hardcoded path
    "--with-pkcs11-config=$$out/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=$$out/lib/pkcs11/"
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
