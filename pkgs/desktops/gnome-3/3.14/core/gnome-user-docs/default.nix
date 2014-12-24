{ stdenv, fetchurl, pkgconfig, file, gnome3, itstool, libxml2, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-user-docs-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${gnome3.version}/${name}.tar.xz";
    sha256 = "ee89e0891fcad30ceb9e93e57a40e59730e0fee7973be233e0c4992b1d5726f1";
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
