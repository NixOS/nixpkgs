{ stdenv, fetchurl, pkgconfig, file, gnome3, itstool, libxml2, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-user-docs-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/3.12/${name}.tar.xz";
    sha256 = "1cj45lpa74vkbxyila3d6pn5m1gh51nljp9fjirxmzwi1h6wg7jd";
  };

  buildInputs = [ pkgconfig gnome3.yelp itstool libxml2 intltool ];

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-help/3.12;
    description = "User and system administration help for the Gnome desktop";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.cc-by-30;
    platforms = platforms.linux;
  };
}
