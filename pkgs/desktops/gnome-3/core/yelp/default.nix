{ stdenv, gettext, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, gnome3, sqlite
, itstool, libxml2, libxslt, gst_all_1
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "yelp";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "097djjyl096zmicjpxlb858yz6rd5cj813xc8azbxlhsscikwjzx";
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
