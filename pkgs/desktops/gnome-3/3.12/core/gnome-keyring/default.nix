{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python, glib, libxslt
, intltool, pango, gcr, gdk_pixbuf, atk, p11_kit, makeWrapper
, docbook_xsl_ns, docbook_xsl, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-keyring-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/3.12/${name}.tar.xz";
    sha256 = "3bc39a42d445b82d24247a8c39eeb0eef7ecb1c8ebb8e6ec62671868be93fd4c";
  };

  buildInputs = with gnome3; [
    dbus libgcrypt pam python gtk3 gconf libgnome_keyring
    pango gcr gdk_pixbuf atk p11_kit makeWrapper
  ];

  propagatedBuildInputs = [ glib libtasn1 libxslt ];

  nativeBuildInputs = [ pkgconfig intltool docbook_xsl_ns docbook_xsl ];

  configureFlags = [
    "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt" # NixOS hardcoded path
    "--with-pkcs11-config=$$out/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=$$out/lib/pkcs11/"
  ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-keyring" \
      --prefix XDG_DATA_DIRS : "${glib}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
    wrapProgram "$out/bin/gnome-keyring-daemon" \
      --prefix XDG_DATA_DIRS : "${glib}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
