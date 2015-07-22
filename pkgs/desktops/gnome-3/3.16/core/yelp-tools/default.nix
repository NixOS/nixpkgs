{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

let
  majVer = gnome3.version;
in stdenv.mkDerivation rec {
  name = "yelp-tools-${majVer}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${majVer}/${name}.tar.xz";
    sha256 = "177qzvj5w019isdp41qxqcys2kc4sq2x6dqhqn6l9ipib8a6rxml";
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
