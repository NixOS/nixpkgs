{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "yelp-tools";
  version = "3.32.2";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1yg8f5g5wadhmy4yfd9yjhvd8vll4gq4l86ibp0b42qbxnsmcf0q";
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
