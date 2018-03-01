{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

stdenv.mkDerivation rec {
  name = "yelp-tools-${version}";
  version = "3.18.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "c6c1d65f802397267cdc47aafd5398c4b60766e0a7ad2190426af6c0d0716932";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "yelp-tools"; attrPath = "gnome3.yelp-tools"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 libxslt itstool gnome3.yelp-xsl ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp/Tools;
    description = "Small programs that help you create, edit, manage, and publish your Mallard or DocBook documentation";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
