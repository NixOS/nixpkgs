{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, gnome3, sqlite
, itstool, libxml2, libxslt, gst_all_1
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "yelp-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "090klk2mhd87y5w228gd1ia1lvvxaj913lkvxzcb1apz8n0i8mm7";
  };

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook ];
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
