{
  stdenv,
  lib,
  fetchurl,
  desktop-file-utils,
  gettext,
  itstool,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  bzip2,
  glib,
  gtk4,
  libadwaita,
  libxml2,
  libxslt,
  sqlite,
  webkitgtk_6_0,
  xz,
  yelp-xsl,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "yelp";
  version = "49.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${lib.versions.major version}/yelp-${version}.tar.xz";
    hash = "sha256-c6p+V6xKB5lllUdR0fgBPA4B8NlfCQ0Zaap5K4QDEqw=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    bzip2
    glib
    gtk4
    libadwaita
    libxml2
    libxslt
    sqlite
    webkitgtk_6_0
    xz
    yelp-xsl
  ];

  postPatch = ''
    chmod +x src/link-gnome-help.sh data/domains/gen_yelp_xml.sh
    patchShebangs src/link-gnome-help.sh
    patchShebangs data/domains/gen_yelp_xml.sh
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "yelp";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Yelp/";
    description = "Help viewer for GNOME";
    teams = [ teams.gnome ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
