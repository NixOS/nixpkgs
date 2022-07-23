{ lib
, stdenv
, fetchurl
, substituteAll
, pkg-config
, meson
, ninja
, gettext
, gnome
, wrapGAppsHook
, packagekit
, ostree
, glib
, appstream
, libsoup
, libadwaita
, polkit
, isocodes
, gspell
, libxslt
, gobject-introspection
, flatpak
, fwupd
, gtk4
, gsettings-desktop-schemas
, gnome-desktop
, libgudev
, libxmlb
, malcontent
, json-glib
, libsecret
, valgrind-light
, docbook-xsl-nons
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, gtk-doc
, desktop-file-utils
, libsysprof-capture
}:

let
  withFwupd = stdenv.hostPlatform.isx86;
in

stdenv.mkDerivation rec {
  pname = "gnome-software";
  version = "43.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "Xx913hkGKXJyBeubS886hP1tpwxAdZAXB6V3sOh5P6g=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit isocodes;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook
    libxslt
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    valgrind-light
    docbook-xsl-nons
    gtk-doc
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    glib
    packagekit
    appstream
    libsoup
    libadwaita
    gsettings-desktop-schemas
    gnome-desktop
    gspell
    json-glib
    libsecret
    ostree
    polkit
    flatpak
    libgudev
    libxmlb
    malcontent
    libsysprof-capture
  ] ++ lib.optionals withFwupd [
    fwupd
  ];

  mesonFlags = [
    # Needs flatpak to upgrade
    "-Dsoup2=true"
    # Requires /etc/machine-id, D-Bus system bus, etc.
    "-Dtests=false"
  ] ++ lib.optionals (!withFwupd) [
    "-Dfwupd=false"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.gnome-software";
    };
  };

  meta = with lib; {
    description = "Software store that lets you install and update applications and system extensions";
    homepage = "https://wiki.gnome.org/Apps/Software";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
