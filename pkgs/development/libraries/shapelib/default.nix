{ stdenv, fetchurl, proj }:

stdenv.mkDerivation rec {
  name = "shapelib-1.4.0";

  src = fetchurl {
    url = "https://download.osgeo.org/shapelib/${name}.tar.gz";
    sha256 = "18d7j5pn5srika7q3f90j0l2l4526xsjd64pin6z2b0gd7rdbp9y";
  };

  buildInputs =  [ proj ];

  meta = with stdenv.lib; {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = http://shapelib.maptools.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
  };
}
