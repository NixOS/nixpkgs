{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

stdenv.mkDerivation rec {
  name = "yelp-tools-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/3.12/${name}.tar.xz";
    sha256 = "7a5370d7adbec3b6e6b7b5e7e5ed966cb99c797907a186b94b93c184e97f0172";
  };

  buildInputs = [ libxml2 libxslt itstool gnome3.yelp_xsl pkgconfig ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp/Tools;
    description = "Small programs that help you create, edit, manage, and publish your Mallard or DocBook documentation";
    maintainers = with maintainers; [ iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
