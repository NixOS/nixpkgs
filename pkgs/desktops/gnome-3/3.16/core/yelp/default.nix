{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, gnome3, gdk_pixbuf, sqlite
, bash, makeWrapper, itstool, libxml2, libxslt, icu, gst_all_1
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "yelp-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${gnome3.version}/${name}.tar.xz";
    sha256 = "1jk7aad1srykhgc3x0hd3q3dnlshmy1ak00alwjzaasxvy6hp0b0";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 glib webkitgtk intltool itstool sqlite
                  libxml2 libxslt icu file makeWrapper gnome3.yelp_xsl
                  librsvg gdk_pixbuf gnome3.defaultIconTheme
                  gnome3.gsettings_desktop_schemas wrapGAppsHook
                  gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "The help viewer in Gnome";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
