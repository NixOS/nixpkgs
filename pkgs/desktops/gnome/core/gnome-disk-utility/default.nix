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
, python3
, libnotify
, itstool
, gnome
, libxml2
, gsettings-desktop-schemas
, libcanberra-gtk3
, libxslt
, docbook-xsl-nons
, libpwquality
, systemd
}:

stdenv.mkDerivation rec {
  pname = "gnome-disk-utility";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-G2VkRU1nQmMiyzv8WlVYZTv8ff7qKuCCWx0IYp8BCQs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxslt
    docbook-xsl-nons
    wrapGAppsHook
    python3
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

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

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
