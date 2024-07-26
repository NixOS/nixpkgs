{ lib
, stdenv
, fetchurl
, fetchpatch
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

stdenv.mkDerivation rec {
  pname = "gnome-software";
  version = "45.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1rkkWyIjfae9FzndKMI8yPODX5n6EMEDfZ3XY1M1JRw=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit isocodes;
    })

    # Add support for AppStream 1.0.
    # https://gitlab.gnome.org/GNOME/gnome-software/-/issues/2393
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-software/-/commit/0655f358ed0e8455e12d9634f60bc4dbaee434e3.patch";
      hash = "sha256-8IXXUfNeha5yRlRLuxQV8whwQmyNw7Aoi/r5NNFS/zA=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-software/-/commit/e431ab003f3fabf616b6eb7dc93f8967bc9473e5.patch";
      hash = "sha256-Y5GcC1XMbb9Bl2/VKFnrV1B/ipLKxY4guse25LhxhKM=";
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
