{ stdenv, fetchurl, pkgconfig, file, gnome3, itstool, libxml2, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-user-docs-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${gnome3.version}/${name}.tar.xz";
    sha256 = "0cck9hnp9az6qan97cv2d5lxlnzfss38h73g1a6dbspl4bnghy4n";
  };

  buildInputs = [ pkgconfig gnome3.yelp itstool libxml2 intltool ];

  meta = with stdenv.lib; {
    homepage = "https://help.gnome.org/users/gnome-help/${gnome3.version}";
    description = "User and system administration help for the GNOME desktop";
    maintainers = gnome3.maintainers;
    license = licenses.cc-by-30;
    platforms = platforms.linux;
  };
}
