{ stdenv, fetchFromGitHub, fetchpatch, cmake
, qhull, flann, boost, vtk, eigen, pkgconfig, qtbase
, libusb1, libpcap, libXt, libpng, Cocoa, AGL, cf-private, OpenGL
}:

stdenv.mkDerivation rec {
  name = "pcl-1.9.1";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = name;
    sha256 = "0g0am3bf14sadfw231l5nmf5d2g1p9i7yq12c6q8rl7nw501ny9j";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qhull flann boost eigen libusb1 libpcap
                  libpng vtk qtbase libXt ]

    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa AGL cf-private ];
  cmakeFlags = stdenv.lib.optionals stdenv.isDarwin [
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
