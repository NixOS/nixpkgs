{ stdenv, fetchFromGitHub, cmake
, qhull, flann, boost, vtk, eigen, pkgconfig, qtbase
, libusb1, libpcap, libXt, libpng, Cocoa, AGL, OpenGL
}:

stdenv.mkDerivation rec {
  name = "pcl-1.11.1";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = name;
    sha256 = "1cli2rxqsk6nxp36p5mgvvahjz8hm4fb68yi8cf9nw4ygbcvcwb1";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qhull flann boost eigen libusb1 libpcap
                  libpng vtk qtbase libXt ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa AGL ];

  cmakeFlags = stdenv.lib.optionals stdenv.isDarwin [
    "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"
  ];

  meta = {
    homepage = "https://pointclouds.org/";
    broken = stdenv.lib.versionAtLeast qtbase.version "5.15";
    description = "Open project for 2D/3D image and point cloud processing";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
