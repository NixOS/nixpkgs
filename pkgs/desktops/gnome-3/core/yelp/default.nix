{ lib, stdenv, gettext, fetchurl, webkitgtk, pkg-config, gtk3, glib
, gnome3, sqlite
, itstool, libxml2, libxslt, gst_all_1
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "yelp";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-B3dfoGzSg2Xs2Cm7FqhaaCiXqyHYzONFlrvvXNRVquA=";
  };

  nativeBuildInputs = [ pkg-config gettext itstool wrapGAppsHook ];
  buildInputs = [
    gtk3 glib webkitgtk sqlite
    libxml2 libxslt gnome3.yelp-xsl
    gnome3.adwaita-icon-theme
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "yelp";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Yelp";
    description = "The help viewer in Gnome";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
