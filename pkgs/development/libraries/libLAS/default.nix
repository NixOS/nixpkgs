{ stdenv, fetchurl, boost, cmake, gdal, libgeotiff, libtiff, LASzip }:

stdenv.mkDerivation rec {
  name = "libLAS-1.8.1";

  src = fetchurl {

    url = "http://download.osgeo.org/liblas/${name}.tar.bz2";
    sha256 = "0xjfxb3ydvr2258ji3spzyf81g9caap19ql2pk91wiivqsc4mnws";
  };

  buildInputs = [ boost cmake gdal libgeotiff libtiff LASzip ];


  meta = {
    description = "LAS 1.0/1.1/1.2 ASPRS LiDAR data translation toolset";
    homepage = http://www.liblas.org;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.michelk ];
  };
}
