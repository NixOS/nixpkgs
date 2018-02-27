{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, gnome3, gdk_pixbuf, sqlite, groff
, bash, makeWrapper, itstool, libxml2, libxslt, icu, gst_all_1
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib webkitgtk intltool itstool sqlite
                  libxml2 libxslt icu file makeWrapper gnome3.yelp-xsl
                  librsvg gdk_pixbuf gnome3.defaultIconTheme groff
                  gnome3.gsettings-desktop-schemas wrapGAppsHook
                  gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "The help viewer in Gnome";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
