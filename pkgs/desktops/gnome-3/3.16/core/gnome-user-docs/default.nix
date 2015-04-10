{ stdenv, fetchurl, pkgconfig, file, gnome3, itstool, libxml2, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-user-docs-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${gnome3.version}/${name}.tar.xz";
    sha256 = "031gmqllbl9jn77c94xzx55rm1wq8i4cwkxdzdla9c8aq82xshyc";
  };

  buildInputs = [ pkgconfig gnome3.yelp itstool libxml2 intltool ];

  meta = with stdenv.lib; {
    homepage = "https://help.gnome.org/users/gnome-help/${gnome3.version}";
    description = "User and system administration help for the GNOME desktop";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.cc-by-30;
    platforms = platforms.linux;
  };
}
