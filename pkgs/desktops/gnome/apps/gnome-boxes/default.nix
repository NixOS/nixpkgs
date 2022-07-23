{ stdenv
, lib
, fetchurl
, meson
, ninja
, wrapGAppsHook
, pkg-config
, gettext
, itstool
, libvirt-glib
, glib
, gobject-introspection
, libxml2
, gtk3
, gtksourceview4
, libvirt
, spice-gtk
, python3
, appstream-glib
, spice-protocol
, libhandy
, libsoup_3
, libosinfo
, systemd
, tracker
, tracker-miners
, vala
, libcap
, yajl
, gmp
, gdbm
, cyrus_sasl
, gnome
, librsvg
, desktop-file-utils
, mtools
, cdrkit
, libcdio
, libusb1
, libarchive
, acl
, libgudev
, libsecret
, libcap_ng
, numactl
, libapparmor
, json-glib
, webkitgtk_4_1
, vte
, glib-networking
, qemu-utils
, qemu
}:

stdenv.mkDerivation rec {
  pname = "gnome-boxes";
  version = "43.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "BEUHGaCDN8/fF1D18N82gwc7Xg6kisynSb4j0Ev7+yY=";
  };

  patches = [
    # Fix path to libgovf-0.1.so in the gir file. We patch gobject-introspection to hardcode absolute paths but
    # our Meson patch will only pass the info when install_dir is absolute as well.
    ./fix-gir-lib-path.patch
  ];

  doCheck = true;

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = [
    spice-gtk
  ];

  buildInputs = [
    acl
    cyrus_sasl
    gdbm
    glib
    glib-networking
    gmp
    gnome.adwaita-icon-theme
    gtk3
    gtksourceview4
    json-glib
    libapparmor
    libarchive
    libcap
    libcap_ng
    libgudev
    libhandy
    libosinfo
    librsvg
    libsecret
    libsoup_3
    libusb1
    libvirt
    libvirt-glib
    libxml2
    numactl
    spice-gtk
    spice-protocol
    systemd
    tracker
    tracker-miners
    vte
    webkitgtk_4_1
    yajl
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ mtools cdrkit libcdio qemu-utils qemu ]}")
  '';

  postPatch = ''
    chmod +x build-aux/post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "Simple GNOME 3 application to access remote or virtual systems";
    homepage = "https://wiki.gnome.org/Apps/Boxes";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
