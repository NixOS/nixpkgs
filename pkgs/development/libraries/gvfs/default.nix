{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gettext
, dbus
, glib
, libgudev
, udisks2
, libgcrypt
, libcap
, polkit
, libgphoto2
, avahi
, libarchive
, fuse3
, libcdio
, libxml2
, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, samba
, libmtp
, gnomeSupport ? false
, gnome3
, gcr
, glib-networking
, gnome-online-accounts
, wrapGAppsHook
, libimobiledevice
, libbluray
, libcdio-paranoia
, libnfs
, openssh
, libsecret
, libgdata
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gvfs";
  version = "1.46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1sbhv7smfah5nijmv9k3chhylnyx4rnb8xn7mkiir8h9vak77fkq";
  };

  postPatch = ''
    # patchShebangs requires executable file
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    patchShebangs test test-driver
  '';

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkgconfig
    gettext
    wrapGAppsHook
    libxml2
    libxslt
    docbook_xsl
    docbook_xml_dtd_42
  ];

  buildInputs = [
    glib
    libgudev
    udisks2
    libgcrypt
    dbus
    libgphoto2
    avahi
    libarchive
    fuse3
    libcdio
    samba
    libmtp
    libcap
    polkit
    libimobiledevice
    libbluray
    libcdio-paranoia
    libnfs
    openssh
    gsettings-desktop-schemas
    # TODO: a ligther version of libsoup to have FTP/HTTP support?
  ] ++ stdenv.lib.optionals gnomeSupport [
    gnome3.libsoup
    gcr
    glib-networking # TLS support
    gnome-online-accounts
    libsecret
    libgdata
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
    "-Dtmpfilesdir=no"
  ] ++ stdenv.lib.optionals (!gnomeSupport) [
    "-Dgcr=false"
    "-Dgoa=false"
    "-Dkeyring=false"
    "-Dhttp=false"
    "-Dgoogle=false"
  ] ++ stdenv.lib.optionals (samba == null) [
    # Xfce don't want samba
    "-Dsmb=false"
  ];

  doCheck = false; # fails with "ModuleNotFoundError: No module named 'gi'"
  doInstallCheck = doCheck;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Virtual Filesystem support library" + optionalString gnomeSupport " (full GNOME support)";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ] ++ teams.gnome.members;
  };
}
