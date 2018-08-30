{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, pam, python2, glib, libxslt
, gettext, gcr, libcap_ng, libselinux, p11-kit, openssh, wrapGAppsHook
, docbook_xsl, docbook_xml_dtd_43, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-keyring-${version}";
  version = "3.28.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0sk4las4ji8wv9nx8mldzqccmpmkvvr9pdwv9imj26r10xyin5w1";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    glib libgcrypt pam openssh libcap_ng libselinux
    gcr p11-kit
  ];

  nativeBuildInputs = [
    pkgconfig gettext libxslt docbook_xsl docbook_xml_dtd_43 wrapGAppsHook
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

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-keyring";
      attrPath = "gnome3.gnome-keyring";
    };
  };

  meta = with stdenv.lib; {
    description = "Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications";
    homepage = https://wiki.gnome.org/Projects/GnomeKeyring;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
