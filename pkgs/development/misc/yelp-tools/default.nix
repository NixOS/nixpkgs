{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "yelp-tools";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1c045c794sm83rrjan67jmsk20qacrw1m814p4nw85w5xsry8z30";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 libxslt itstool gnome3.yelp-xsl ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Yelp/Tools";
    description = "Small programs that help you create, edit, manage, and publish your Mallard or DocBook documentation";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
