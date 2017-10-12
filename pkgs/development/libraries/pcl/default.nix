{ stdenv, fetchFromGitHub, cmake, qhull, flann, boost, vtk, eigen, pkgconfig, qtbase
, libusb1, libpcap, libXt, libpng, Cocoa, AGL, cf-private, OpenGL
}:

stdenv.mkDerivation rec {
  name = "pcl-1.8.1";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = name;
    sha256 = "05wvqqi2fyk5innw4mg356r71c1hmc9alc7xkf4g81ds3b3867xq";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qhull flann boost eigen libusb1 libpcap
                  libpng vtk qtbase libXt ]

    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa AGL cf-private ];
  cmakeFlags = stdenv.lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_SYSROOT=" "-DCMAKE_OSX_DEPLOYMENT_TARGET="
    "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"
  ];

  meta = {
    homepage = http://pointclouds.org/;
    description = "Open project for 2D/3D image and point cloud processing";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
