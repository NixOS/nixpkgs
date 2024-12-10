{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapQtAppsHook,
  cmake,
  qhull,
  flann,
  boost,
  vtk,
  eigen,
  pkg-config,
  qtbase,
  libusb1,
  libpcap,
  libtiff,
  libXt,
  libpng,
  Cocoa,
  AGL,
  OpenGL,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:

stdenv.mkDerivation rec {
  pname = "pcl";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = "${pname}-${version}";
    sha256 = "sha256-JDiDAmdpwUR3Sff63ehyvetIFXAgGOrI+HEaZ5lURps=";
  };

  # remove attempt to prevent (x86/x87-specific) extended precision use
  # when SSE not detected
  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-ffloat-store/d' cmake/pcl_find_sse.cmake
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs =
    [
      eigen
      libusb1
      libpcap
      qtbase
      libXt
    ]
    ++ lib.optionals stdenv.isDarwin [
      Cocoa
      AGL
    ];

  propagatedBuildInputs = [
    boost
    flann
    libpng
    libtiff
    qhull
    vtk
  ];

  cmakeFlags =
    lib.optionals stdenv.isDarwin [
      "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"
    ]
    ++ lib.optionals cudaSupport [ "-DWITH_CUDA=true" ];

  meta = {
    homepage = "https://pointclouds.org/";
    description = "Open project for 2D/3D image and point cloud processing";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
