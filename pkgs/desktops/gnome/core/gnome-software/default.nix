{ lib
, stdenv
, fetchurl
, substituteAll
, pkg-config
, meson
, ninja
, gettext
, gnome
, wrapGAppsHook4
, packagekit
, ostree
, glib
, appstream
, libsoup_3
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
, glib-networking
, libsecret
, valgrind-light
, docbook-xsl-nons
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, gtk-doc
, desktop-file-utils
, libsysprof-capture
, gst_all_1
}:

let
  withFwupd = stdenv.hostPlatform.isx86;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-software";
  version = "46.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${lib.versions.major finalAttrs.version}/gnome-software-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZVTR3gfnxjUtqLBjhP6hPaZJnXHAW1rQANjiHLFT9a8=";
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
    wrapGAppsHook4
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
    glib-networking
    packagekit
    appstream
    libsoup_3
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
    # For video screenshots
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ] ++ lib.optionals withFwupd [
    fwupd
  ];

  mesonFlags = [
    # Requires /etc/machine-id, D-Bus system bus, etc.
    "-Dtests=false"
  ] ++ lib.optionals (!withFwupd) [
    "-Dfwupd=false"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-software";
      attrPath = "gnome.gnome-software";
    };
  };

  meta = with lib; {
    description = "Software store that lets you install and update applications and system extensions";
    mainProgram = "gnome-software";
    homepage = "https://apps.gnome.org/Software/";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
