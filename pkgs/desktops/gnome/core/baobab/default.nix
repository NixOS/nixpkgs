{
  stdenv,
  lib,
  gettext,
  fetchurl,
  vala,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  gtk4,
  libadwaita,
  glib,
  libxml2,
  wrapGAppsHook4,
  itstool,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "baobab";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-zk3vXILQVnGlAJ9768+FrJhnXZ2BYNKK2RgbJppy43w=";
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
    mainProgram = "baobab";
    homepage = "https://apps.gnome.org/Baobab/";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
