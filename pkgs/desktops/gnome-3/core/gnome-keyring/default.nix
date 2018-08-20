{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python2, glib, libxslt
, intltool, pango, gcr, gdk_pixbuf, atk, p11-kit, openssh, wrapGAppsHook
, docbook_xsl, docbook_xml_dtd_42, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-keyring-${version}";
  version = "3.28.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0sk4las4ji8wv9nx8mldzqccmpmkvvr9pdwv9imj26r10xyin5w1";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-keyring"; attrPath = "gnome3.gnome-keyring"; };
  };

  outputs = [ "out" "dev" ];

  buildInputs = with gnome3; [
    dbus libgcrypt pam gtk3 libgnome-keyring openssh
    pango gcr gdk_pixbuf atk p11-kit
  ];

  propagatedBuildInputs = [ glib libtasn1 libxslt ];

  nativeBuildInputs = [
    pkgconfig intltool docbook_xsl docbook_xml_dtd_42 wrapGAppsHook
  ];

  configureFlags = [
    "--with-pkcs11-config=$$out/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=$$out/lib/pkcs11/"
  ];

  postPatch = ''
    patchShebangs build
  '';

  doCheck = true;
  # In 3.20.1, tests do not support Python 3
  checkInputs = [ dbus python2 ];

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
