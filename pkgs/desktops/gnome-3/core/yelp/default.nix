{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, gnome3, sqlite
, itstool, libxml2, libxslt, gst_all_1
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "yelp-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "05qzczxnxk374cp4an166gv60nkbd0jq3pp2fwy7s9rnkm55jz6v";
  };

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook ];
  buildInputs = [
    gtk3 glib webkitgtk sqlite
    libxml2 libxslt gnome3.yelp-xsl
    gnome3.defaultIconTheme
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
