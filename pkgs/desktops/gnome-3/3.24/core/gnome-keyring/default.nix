{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python, glib, libxslt
, intltool, pango, gcr, gdk_pixbuf, atk, p11_kit, wrapGAppsHook
, docbook_xsl_ns, docbook_xsl, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = with gnome3; [
    dbus libgcrypt pam python gtk3 gconf libgnome_keyring
    pango gcr gdk_pixbuf atk p11_kit
  ];

  propagatedBuildInputs = [ glib libtasn1 libxslt ];

  nativeBuildInputs = [ pkgconfig intltool docbook_xsl_ns docbook_xsl wrapGAppsHook ];

  configureFlags = [
    "--with-pkcs11-config=$$out/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=$$out/lib/pkcs11/"
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
