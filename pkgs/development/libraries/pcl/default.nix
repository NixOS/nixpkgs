{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "pcl";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    tag = "pcl-${finalAttrs.version}";
    hash = "sha256-vu5pG4/FE8GCJfd8OZbgRguGJMMZr9PEEdbxUsuV/5Q=";
  };

  patches = [
    # Fix build with boost 1.86
    (fetchpatch {
      url = "https://github.com/PointCloudLibrary/pcl/commit/c6bbf02a084a39a02d9e2fc318a59fe2f1ff55c1.patch";
      hash = "sha256-UIqq42pK6vHic0wZK/tP8wnsFZ98krh706RAJ9Hw3jA=";
    })
    # Fix build with Clang 19
    (fetchpatch {
      url = "https://github.com/PointCloudLibrary/pcl/commit/6f1105a4c30416a55196db048ef9759e22cdd04e.patch";
      hash = "sha256-Ftgz2UOmGJSOxAOuIS7NNWoIaPpjqhaTeOqpEnDNodk=";
    })
    # Fix build with boost 1.87
    (fetchpatch {
      url = "https://github.com/PointCloudLibrary/pcl/commit/0932486c52a2cf4f0821e25d5ea2d5767fff8381.patch";
      hash = "sha256-+MsgsRPIAHOynIYbUWh4jL3pxnnyxzCuTVEr07dU8AU=";
    })
  ];

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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    [
      (lib.cmakeBool "PCL_ENABLE_MARCHNATIVE" false)
      (lib.cmakeBool "WITH_CUDA" cudaSupport)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"
    ];

  meta = {
    homepage = "https://pointclouds.org/";
    description = "Open project for 2D/3D image and point cloud processing";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
