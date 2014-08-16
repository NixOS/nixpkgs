{ stdenv, fetchurl, cmake, qhull, flann, boost, vtk, eigen, pkgconfig, qt4, libusb1 }:

stdenv.mkDerivation {
  name = "pcl-1.6.0";

  buildInputs = [ cmake qhull flann boost vtk eigen pkgconfig qt4 libusb1 ];

  src = fetchurl {
    url = mirror://sourceforge/pointclouds/PCL-1.6.0-Source.tar.bz2;
    sha256 = "0ip3djcjgynlr9vac6jlcw6kxhg2lm8fc0aqk747a6l0rqvllf1x";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = http://pointclouds.org/;
    description = "Open project for 2D/3D image and point cloud processing";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    broken = true;
  };
}
