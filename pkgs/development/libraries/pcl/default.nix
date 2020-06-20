{ stdenv, fetchFromGitHub, cmake
, qhull, flann, boost, vtk, eigen, pkgconfig, qtbase
, libusb1, libpcap, libXt, libpng, Cocoa, AGL, OpenGL
}:

stdenv.mkDerivation rec {
  name = "pcl-1.11.0";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = name;
    sha256 = "0nr3j71gh1v8x6wjr7a7xyr0438sw7vf621a5kbw4lmsxbj55k8g";
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
    homepage = "http://pointclouds.org/";
    description = "Open project for 2D/3D image and point cloud processing";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
