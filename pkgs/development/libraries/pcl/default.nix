{ stdenv, fetchzip, cmake, qhull, flann, boost, vtk, eigen, pkgconfig, qt4
, libusb1, libpcap, libXt, libpng
}:

stdenv.mkDerivation rec {
  name = "pcl-1.7.2";

  src = fetchzip {
    name = name + "-src";
    url = "https://github.com/PointCloudLibrary/pcl/archive/${name}.tar.gz";
    sha256 = "0sm19p6wcls2d9l0vi5fgwqp7l372nh3g7bdin42w31zr8dmz8h8";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake qhull flann boost eigen pkgconfig libusb1 libpcap
                  libpng vtk qt4 libXt ];

  meta = {
    homepage = http://pointclouds.org/;
    description = "Open project for 2D/3D image and point cloud processing";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
