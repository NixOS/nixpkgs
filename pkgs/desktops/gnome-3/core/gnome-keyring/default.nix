{stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python, glib
, gtk3, intltool, gconf, libgnome_keyring, pango, gcr, gdk_pixbuf, atk, p11_kit }:

stdenv.mkDerivation rec {
  name = "gnome-keyring-3.6.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/3.6/${name}.tar.xz";
    sha256 = "1mhc2c0qswfjqi2spdvh19b7npfkjf1k40q6v7fja4qpc26maq5f";
  };

  buildInputs = [
    dbus libgcrypt pam python gtk3 gconf libgnome_keyring
    pango gcr gdk_pixbuf atk p11_kit
  ];

  propagatedBuildInputs = [ glib libtasn1 ];

  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [
    "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt" # NixOS hardcoded path
    "--with-pkcs11-config=$$out/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=$$out/lib/pkcs11/"
  ];
}
