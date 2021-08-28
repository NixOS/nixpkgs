{ lib, stdenv
, meson
, ninja
, gettext
, fetchurl
, fetchpatch
, evince
, gjs
, pkg-config
, gtk3
, glib
, tracker
, tracker-miners
, itstool
, libxslt
, webkitgtk
, libgdata
, gnome-desktop
, libzapojit
, libgepub
, gnome
, gdk-pixbuf
, libsoup
, docbook_xsl
, docbook_xml_dtd_42
, gobject-introspection
, inkscape
, poppler_utils
, desktop-file-utils
, wrapGAppsHook
, python3
, appstream-glib
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-documents";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-documents/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1qph567mapg3s1a26k7b8y57g9bklhj2mh8xm758z9zkms20xafq";
  };

  patches = [
    # Fix inkscape 1.0 usage
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-documents/commit/0f55a18c40a61e6ae4ec4652604775f139892350.diff";
      sha256 = "1yrisq69dl1dn7639drlbza20a5ic6xg04ksr9iq4sxdx3xj3d8s";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxslt
    desktop-file-utils
    docbook_xsl
    docbook_xml_dtd_42
    wrapGAppsHook
    python3
    appstream-glib

    # building getting started
    inkscape
    poppler_utils
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    gdk-pixbuf
    gnome.adwaita-icon-theme
    evince
    libsoup
    webkitgtk
    gjs
    gobject-introspection
    tracker
    tracker-miners
    libgdata
    gnome-desktop
    libzapojit
    libgepub
  ];

  doCheck = true;

  mesonFlags = [
    "-Dgetting_started=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    substituteInPlace $out/bin/gnome-documents --replace gapplication "${glib.bin}/bin/gapplication"
  '';

  preConfigure =
    # To silence inkscape warnings regarding profile directory
  ''
    export INKSCAPE_PROFILE_DIR="$(mktemp -d)"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    broken = true; # Tracker 3 not supported and it cannot start Tracker 2.
    homepage = "https://wiki.gnome.org/Apps/Documents";
    description = "Document manager application designed to work with GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
