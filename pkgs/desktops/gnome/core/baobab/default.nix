{ stdenv
, lib
, gettext
, fetchurl
, vala
, desktop-file-utils
, meson
, ninja
, pkg-config
, gtk4
, libadwaita
, glib
, libxml2
, wrapGAppsHook4
, itstool
, gnome
}:

stdenv.mkDerivation rec {
  pname = "baobab";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "hFtju5Ej10VoyBJsVxu8dCc0g/+SAXmizx7du++hv8A=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib
    itstool
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
    # Prevents “error: Package `libadwaita-1' not found in specified Vala API
    # directories or GObject-Introspection GIR directories” with strictDeps,
    # even though it should only be a runtime dependency.
    libadwaita
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    homepage = "https://wiki.gnome.org/Apps/DiskUsageAnalyzer";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
