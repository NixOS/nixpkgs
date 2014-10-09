{ stdenv, fetchurl, boost, cmake, gdal, libgeotiff, libtiff, LASzip }:

stdenv.mkDerivation rec {
  name = "libLAS-1.8.0";

  src = fetchurl {

    url = "http://download.osgeo.org/liblas/${name}.tar.bz2";
    md5 = "599881281d45db4ce9adb2d75458391e";
  };

  buildInputs = [ boost cmake gdal libgeotiff libtiff LASzip];


  meta = {
    description = "LAS 1.0/1.1/1.2 ASPRS LiDAR data translation toolset";
    homepage = http://www.liblas.org;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.michelk ];
  };
}
