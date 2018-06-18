{ fetchurl, stdenv, meson, ninja, pkgconfig, gnome3, glib, gtk, gsettings-desktop-schemas
, gnome-desktop, dbus, json-glib, libICE, xmlto, docbook_xsl, docbook_xml_dtd_412
, libxslt, gettext, systemd, xorg, epoxy, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "gnome-session-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "14nmbirgrp2nm16khbz109saqdlinlbrlhjnbjydpnrlimfgg4xq";
  };

  mesonFlags = [ "-Dsystemd=true" ];

  nativeBuildInputs = [
    dbus # for DTD
    docbook_xml_dtd_412
    docbook_xsl
    gettext
    libxslt
    meson
    ninja
    pkgconfig
    wrapGAppsHook
    xmlto
  ];

  buildInputs = [
    epoxy
    glib
    gnome-desktop
    gnome3.defaultIconTheme
    gnome3.gnome-settings-daemon
    gsettings-desktop-schemas
    gtk
    json-glib
    libICE
    systemd
    xorg.xtrans
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    for desktopFile in $(grep -rl "Exec=gnome-session" $out/share); do
      echo "Patching gnome-session path in: $desktopFile"
      sed -i "s,^Exec=gnome-session,Exec=$out/bin/gnome-session," $desktopFile
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-session";
      attrPath = "gnome3.gnome-session";
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME session manager";
    homepage = https://wiki.gnome.org/Projects/SessionManagement;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
