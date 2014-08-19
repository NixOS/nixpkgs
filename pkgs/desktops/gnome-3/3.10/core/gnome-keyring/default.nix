{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python, glib, libxslt
, intltool, pango, gcr, gdk_pixbuf, atk, p11_kit, makeWrapper
, docbook_xsl_ns, docbook_xsl, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-keyring-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/3.10/${name}.tar.xz";
    sha256 = "1y6v2p14jx5h6yh14c53pd8r0r5zbmcgw8v4nxvf94kd9jliy00q";
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
