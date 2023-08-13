{ lib
, stdenv
, gettext
, fetchurl
, pkg-config
, udisks2
, libhandy
, libsecret
, libdvdread
, meson
, ninja
, gtk3
, glib
, wrapGAppsHook
, libnotify
, itstool
, gnome
, libxml2
, gsettings-desktop-schemas
, libcanberra-gtk3
, libxslt
, docbook-xsl-nons
, desktop-file-utils
, libpwquality
, systemd
}:

stdenv.mkDerivation rec {
  pname = "gnome-disk-utility";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-AgMQl4ls2zfYcXpYI/k+NyPU385/3EACyd/LFrfno+8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxslt
    docbook-xsl-nons
    desktop-file-utils
    wrapGAppsHook
    libxml2
  ];

  buildInputs = [
    gtk3
    glib
    libhandy
    libsecret
    libpwquality
    libnotify
    libdvdread
    libcanberra-gtk3
    udisks2
    gnome.adwaita-icon-theme
    systemd
    gnome.gnome-settings-daemon
    gsettings-desktop-schemas
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-disk-utility";
      attrPath = "gnome.gnome-disk-utility";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Disks";
    description = "A udisks graphical front-end";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "gnome-disks";
  };
}
