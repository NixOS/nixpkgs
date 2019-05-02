{ stdenv, gettext, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, gnome3, sqlite
, itstool, libxml2, libxslt, gst_all_1
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "yelp-${version}";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "159ayfyswn9yh7g5hjs6lphh510n6qkyd1cj47hnc3ynnab9hn4r";
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
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "The help viewer in Gnome";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
