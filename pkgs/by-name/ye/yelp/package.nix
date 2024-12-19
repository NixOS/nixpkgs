{
  lib,
  stdenv,
  gettext,
  fetchurl,
  webkitgtk_4_1,
  pkg-config,
  gtk3,
  libhandy,
  glib,
  gnome,
  adwaita-icon-theme,
  sqlite,
  itstool,
  libxml2,
  libxslt,
  gst_all_1,
  wrapGAppsHook3,
  yelp-xsl,
}:

stdenv.mkDerivation rec {
  pname = "yelp";
  version = "42.2";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${lib.versions.major version}/yelp-${version}.tar.xz";
    hash = "sha256-osX9B4epCJxyLMZr0Phc33CI2HDntsyFeZ+OW/+erEs=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libhandy
    glib
    webkitgtk_4_1
    sqlite
    libxml2
    libxslt
    yelp-xsl
    adwaita-icon-theme
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "yelp";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Yelp/";
    description = "Help viewer in Gnome";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
