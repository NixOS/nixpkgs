{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, qhull
, flann
, boost
, vtk
, eigen
, pkg-config
, qtbase
, libusb1
, libpcap
, libtiff
, libXt
, libpng
, Cocoa
, AGL
, OpenGL
, withCuda ? false, cudatoolkit
}:

stdenv.mkDerivation rec {
  pname = "pcl";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = "${pname}-${version}";
    sha256 = "0jhvciaw43y6iqqk7hyxnfhn1b4bsw5fpy04s01r5pkcsjjbdbqc";
  };

  nativeBuildInputs = [ pkg-config cmake wrapQtAppsHook ];
  buildInputs = [
    eigen
    libusb1
    libpcap
    qtbase
    libXt
  ]
  ++ lib.optionals stdenv.isDarwin [ Cocoa AGL ]
  ++ lib.optionals withCuda [ cudatoolkit ];

  propagatedBuildInputs = [
    boost
    flann
    libpng
    libtiff
    qhull
    vtk
  ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
    "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"
  ] ++ lib.optionals withCuda [ "-DWITH_CUDA=true" ];

  meta = {
    homepage = "https://pointclouds.org/";
    description = "Open project for 2D/3D image and point cloud processing";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
