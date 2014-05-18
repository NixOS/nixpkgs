{ stdenv, fetchurl, pkgconfig, file, gnome3, itstool, libxml2, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-user-docs-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/3.12/${name}.tar.xz";
    sha256 = "bfd084d72c688d6efb0c34bb572a704cc2ce093c97a33390eaffb5e42158d418";
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
