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
, libhandy
, polkit
, isocodes
, gspell
, libxslt
, gobject-introspection
, flatpak
, fwupd
, gtk3
, gsettings-desktop-schemas
, gnome-desktop
, libxmlb
, gnome-online-accounts
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
  withFwupd = stdenv.isx86_64 || stdenv.isi686;
in

stdenv.mkDerivation rec {
  pname = "gnome-software";
  version = "40.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "voxhGoAvcXGNzLvUVE7ZaIcxGYRv03t7dqeq1yx5mL8=";
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
    gtk3
    glib
    packagekit
    appstream
    libsoup
    libhandy
    gsettings-desktop-schemas
    gnome-desktop
    gspell
    json-glib
    libsecret
    ostree
    polkit
    flatpak
    libxmlb
    gnome-online-accounts
    libsysprof-capture
  ] ++ lib.optionals withFwupd [
    fwupd
  ];

  mesonFlags = [
    "-Dgudev=false"
    # FIXME: package malcontent parental controls
    "-Dmalcontent=false"
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
