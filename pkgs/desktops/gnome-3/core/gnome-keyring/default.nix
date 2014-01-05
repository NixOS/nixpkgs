{stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python, glib
, gtk3, intltool, gconf, libgnome_keyring, pango, gcr, gdk_pixbuf, atk, p11_kit }:

stdenv.mkDerivation rec {
  name = "gnome-keyring-3.6.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/3.6/${name}.tar.xz";
    sha256 = "0la107v75vh8v165lk391xg820h8hxa209766wr98pm22qzkl5g0";
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
