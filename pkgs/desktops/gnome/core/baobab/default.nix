{ stdenv
, lib
, gettext
, fetchurl
, vala
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, gtk3
, libhandy
, glib
, libxml2
, wrapGAppsHook
, itstool
, gnome
}:

stdenv.mkDerivation rec {
  pname = "baobab";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "19yii3bdgivxrcka1c4g6dpbmql5nyawwhzlsph7z6bs68nambm6";
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
    python3
    vala
    wrapGAppsHook
    # Prevents “error: Package `libhandy-1' not found in specified Vala API
    # directories or GObject-Introspection GIR directories” with strictDeps,
    # even though it should only be a runtime dependency.
    libhandy
  ];

  buildInputs = [
    gtk3
    libhandy
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
    platforms = platforms.linux;
  };
}
