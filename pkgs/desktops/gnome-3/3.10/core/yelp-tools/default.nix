{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

stdenv.mkDerivation rec {
  name = "yelp-tools-3.10.0";

  src = fetchurl {
    url = "https://download.gnome.org/sources/yelp-tools/3.10/${name}.tar.xz";
    sha256 = "0496xyx1657db22ks3k92al64fp6236y5bgh7s7b0j8hcc112ppz";
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
