{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python2, glib, libxslt
, intltool, pango, gcr, gdk_pixbuf, atk, p11-kit, wrapGAppsHook
, docbook_xsl, docbook_xml_dtd_42, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  outputs = [ "out" "dev" ];

  buildInputs = with gnome3; [
    dbus libgcrypt pam gtk3 libgnome-keyring
    pango gcr gdk_pixbuf atk p11-kit
  ];

  # In 3.20.1, tests do not support Python 3
  checkInputs = [ dbus python2 ];

  propagatedBuildInputs = [ glib libtasn1 libxslt ];

  nativeBuildInputs = [
    pkgconfig intltool docbook_xsl docbook_xml_dtd_42 wrapGAppsHook
  ] ++ stdenv.lib.optionals doCheck checkInputs;

  configureFlags = [
    "--with-pkcs11-config=$$out/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=$$out/lib/pkcs11/"
  ];

  postPatch = ''
    patchShebangs build
  '';

  # Tests are not deterministic https://bugzilla.gnome.org/show_bug.cgi?id=791932
  doCheck = false;
  checkPhase = ''
    export HOME=$(mktemp -d)
    dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  meta = with stdenv.lib; {
    description = "Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications";
    homepage = https://wiki.gnome.org/Projects/GnomeKeyring;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
