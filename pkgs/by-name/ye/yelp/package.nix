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
  wrapGAppsHook3,
  bzip2,
  glib,
  gtk3,
  libadwaita,
  libhandy,
  libxml2,
  libxslt,
  sqlite,
  webkitgtk_6_0,
  xz,
  yelp-xsl,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yelp";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${lib.versions.major finalAttrs.version}/yelp-${finalAttrs.version}.tar.xz";
    hash = "sha256-5mFOCx9Lpf57jRSb3UJnPwMGVvvc1zaumGBxkZfGNFc=";
  };

  nativeBuildInputs = [
    desktop-file-utils # update-desktop-database
    gettext
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    bzip2
    glib
    gtk3
    libadwaita
    libhandy
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

  meta = {
    homepage = "https://apps.gnome.org/Yelp/";
    description = "Help viewer for GNOME";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
