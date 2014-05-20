{ stdenv, fetchurl, pkgconfig, file, gnome3, itstool, libxml2, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-user-docs-3.10.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/3.10/${name}.tar.xz";
    sha256 = "960b6373ea52e41e3deb3501930e024005b29d2cc958bfadc87450a291d2a905";
  };

  buildInputs = [ pkgconfig gnome3.yelp itstool libxml2 intltool ];

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-help/3.10;
    description = "User and system administration help for the Gnome desktop";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.cc-by-30;
    platforms = platforms.linux;
  };
}
