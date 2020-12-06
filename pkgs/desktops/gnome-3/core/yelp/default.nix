{ stdenv, gettext, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, gnome3, sqlite
, itstool, libxml2, libxslt, gst_all_1
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "yelp";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "102z8khj82vdp12c3y86hhxwm1x89xpkpc5zs63c7gg21cbrwdbl";
  };

  nativeBuildInputs = [ pkgconfig gettext itstool wrapGAppsHook ];
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

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Yelp";
    description = "The help viewer in Gnome";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
