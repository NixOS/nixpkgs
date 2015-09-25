{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

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
