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
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "baobab";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "19yii3bdgivxrcka1c4g6dpbmql5nyawwhzlsph7z6bs68nambm6";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    libxml2
    desktop-file-utils
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
    libhandy
    glib
    gnome3.adwaita-icon-theme
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
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
