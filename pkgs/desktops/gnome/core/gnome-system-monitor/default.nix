{ lib
, stdenv
, gettext
, fetchurl
, pkg-config
, gtkmm3
, libxml2
, bash
, gtk3
, libhandy
, glib
, wrapGAppsHook
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
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "wrq37dupKCfEyN5EKT5+PITJ5QdvMZhYh/+Jac7EXm4=";
  };

  patches = [
    # Fix pkexec detection on NixOS.
    ./fix-paths.patch
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
    meson
    ninja
    glib
  ];

  buildInputs = [
    bash
    gtk3
    libhandy
    glib
    libxml2
    gtkmm3
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
