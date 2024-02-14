{ lib
, stdenv
, gettext
, fetchurl
, pkg-config
, gtkmm4
, libxml2
, bash
, gtk4
, libadwaita
, glib
, wrapGAppsHook4
, meson
, ninja
, gsettings-desktop-schemas
, itstool
, gnome
, librsvg
, gdk-pixbuf
, libgtop
, systemd
}:

stdenv.mkDerivation rec {
  pname = "gnome-system-monitor";
  version = "46.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-GxebJawuWHKiwMwDo92UUrqI18Qzanc04GBh86b9w+I=";
  };

  patches = [
    # Fix pkexec detection on NixOS.
    ./fix-paths.patch
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook4
    meson
    ninja
    glib
  ];

  buildInputs = [
    bash
    gtk4
    libadwaita
    glib
    libxml2
    gtkmm4
    libgtop
    gdk-pixbuf
    gnome.adwaita-icon-theme
    librsvg
    gsettings-desktop-schemas
    systemd
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-system-monitor";
      attrPath = "gnome.gnome-system-monitor";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/SystemMonitor";
    description = "System Monitor shows you what programs are running and how much processor time, memory, and disk space are being used";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
