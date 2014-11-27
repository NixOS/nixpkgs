{ stdenv, fetchurl, cmake, qhull, flann, boost, vtk, eigen, pkgconfig, qt4
, libusb1, libXt}:

stdenv.mkDerivation {
  name = "pcl-1.7.2";

  buildInputs = [ cmake qhull flann boost vtk eigen pkgconfig qt4 libusb1 libXt ];

  src = fetchurl {
    url = https://github.com/PointCloudLibrary/pcl/archive/pcl-1.7.2.tar.gz;
    sha256 = "14xfs2zdjlf3pdk1nhj3fvq6qbac3cji2497g2dk39jqqvr897s7";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = http://pointclouds.org/;
    description = "Open project for 2D/3D image and point cloud processing";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
