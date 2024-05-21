{ lib
, stdenv
, fetchurl
, gnome
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, gtk4
, libadwaita
, gettext
, glib
, udev
, upower
, itstool
, libxml2
, wrapGAppsHook4
, libnotify
, gsound
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-bluetooth";
  version = "46.0";

  # TODO: split out "lib"
  outputs = [ "out" "dev" "devdoc" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-E/4edfMXrNvfXoDJAp0uBjLWCpzPcqQ64263VFAh++8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    libxml2
    wrapGAppsHook4
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    python3
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    udev
    upower
    libnotify
    gsound
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-bluetooth";
    description = "Application that lets you manage Bluetooth in the GNOME desktop";
    mainProgram = "bluetooth-sendto";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
