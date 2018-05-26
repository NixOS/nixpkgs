{ stdenv, fetchurl, proj }:

stdenv.mkDerivation rec {
  name = "shapelib-1.4.1";

  src = fetchurl {
    url = "http://download.osgeo.org/shapelib/${name}.tar.gz";
    sha256 = "1cr3b5jfglwisbyzj7fnxp9xysqad0fcmcqvqaja6qap6qblijd4";
  };

  buildInputs =  [ proj ];

  meta = with stdenv.lib; {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = http://shapelib.maptools.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
  };
}
