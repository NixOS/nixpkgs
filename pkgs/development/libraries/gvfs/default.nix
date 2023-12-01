{ stdenv
, lib
, fetchurl
, fetchpatch2
, meson
, ninja
, pkg-config
, substituteAll
, gettext
, dbus
, glib
, udevSupport ? stdenv.isLinux
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
, libsoup_3
, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, samba
, libmtp
, gnomeSupport ? false
, gnome
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
  version = "1.52.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${lib.versions.majorMinor version}/gvfs-${version}.tar.xz";
    hash = "sha256-zb1EQPbQh5Km51ISRMFzhuIL1TfTdRFwmfyPto/pF0E=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-ssh-path.patch;
      ssh_program = "${lib.getBin openssh}/bin/ssh";
    })
  ];

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkg-config
    gettext
    wrapGAppsHook
    libxslt
    docbook_xsl
    docbook_xml_dtd_42
  ];

  buildInputs = [
    glib
    libgcrypt
    dbus
    libgphoto2
    avahi
    libarchive
    libimobiledevice
    libbluray
    libnfs
    libxml2
    gsettings-desktop-schemas
    libsoup_3
  ] ++ lib.optionals udevSupport [
    libgudev
    udisks2
    fuse3
    libcdio
    samba
    libmtp
    libcap
    polkit
    libcdio-paranoia
  ] ++ lib.optionals gnomeSupport [
    gcr
    glib-networking # TLS support
    gnome-online-accounts
    libsecret
    libgdata
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
    "-Dtmpfilesdir=no"
  ] ++ lib.optionals (!udevSupport) [
    "-Dgudev=false"
    "-Dudisks2=false"
    "-Dfuse=false"
    "-Dcdda=false"
    "-Dsmb=false"
    "-Dmtp=false"
    "-Dadmin=false"
    "-Dgphoto2=false"
    "-Dlibusb=false"
    "-Dlogind=false"
  ] ++ lib.optionals (!gnomeSupport) [
    "-Dgcr=false"
    "-Dgoa=false"
    "-Dkeyring=false"
    "-Dgoogle=false"
  ] ++ lib.optionals (avahi == null) [
    "-Ddnssd=false"
  ] ++ lib.optionals (samba == null) [
    # Xfce don't want samba
    "-Dsmb=false"
  ];

  doCheck = false; # fails with "ModuleNotFoundError: No module named 'gi'"
  doInstallCheck = doCheck;

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Virtual Filesystem support library" + optionalString gnomeSupport " (full GNOME support)";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
