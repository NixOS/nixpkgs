{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python, glib, libxslt
, intltool, pango, gcr, gdk_pixbuf, atk, p11_kit, makeWrapper
, docbook_xsl_ns, docbook_xsl, gnome3 }:

let
  majVer = gnome3.version;
in stdenv.mkDerivation rec {
  name = "gnome-keyring-${majVer}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${majVer}/${name}.tar.xz";
    sha256 = "1xg1xha3x3hzlmvdq2zm90hc61pj7pnf9yxxvgq4ynl5af6bp8qm";
  };

  buildInputs = with gnome3; [
    dbus libgcrypt pam python gtk3 gconf libgnome_keyring
    pango gcr gdk_pixbuf atk p11_kit makeWrapper
  ];

  propagatedBuildInputs = [ glib libtasn1 libxslt ];

  nativeBuildInputs = [ pkgconfig intltool docbook_xsl_ns docbook_xsl ];

  configureFlags = [
    "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt" # NixOS hardcoded path
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
    maintainers = gnome3.maintainers;
  };
}
