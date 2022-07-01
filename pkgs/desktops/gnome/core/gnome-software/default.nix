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
, libxmlb
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
  version = "42.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "OM9whWmj12TU0NLt7KqG9Og57CK5ZvQf2tVleKDdM8A=";
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
    libxmlb
    libsysprof-capture
  ] ++ lib.optionals withFwupd [
    fwupd
  ];

  mesonFlags = [
    "-Dgudev=false"
    # FIXME: package malcontent parental controls
    "-Dmalcontent=false"
    # Needs flatpak to upgrade
    "-Dsoup2=true"
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
