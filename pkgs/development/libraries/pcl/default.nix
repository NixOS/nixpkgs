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
    sha256 = "40668357738d682c71929d7bc21a4db39312187855c6456751e2aae9dc6b29de";
  };

  patches = [
    # boost-1.67 compatibility
    (fetchpatch {
      url = "https://github.com/PointCloudLibrary/pcl/commit/2309bdab20fb2a385d374db6a87349199279db18.patch";
      sha256 = "112p4687xrm0vsm0magmkvsm1hpks9hj42fm0lncy3yy2j1v3r4h";
      name = "boost167-random.patch";
  })];

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
