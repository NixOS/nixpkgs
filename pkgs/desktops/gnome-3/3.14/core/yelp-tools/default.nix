{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

stdenv.mkDerivation rec {
  name = "yelp-tools-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${gnome3.version}/${name}.tar.xz";
    sha256 = "000222baf5d2db394df6025591054976b5cecd0b27872601de7538f36520f60f";
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
