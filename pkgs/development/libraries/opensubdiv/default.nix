{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  xorg,
  libGLU,
  libGL,
  glew,
  ocl-icd,
  python3,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  openclSupport ? !cudaSupport,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "opensubdiv";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenSubdiv";
    rev = "v${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-liy6pQyWMk7rw0usrCoLGzZLO7RAg0z2pV/GF2NnOkE=";
  };

  outputs = [
    "out"
    "dev"
    "static"
  ];

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optional cudaSupport [
      cudaPackages.cuda_nvcc
    ];
  buildInputs =
    [
      libGLU
      libGL
      python3
      # FIXME: these are not actually needed, but the configure script wants them.
      glew
      xorg.libX11
      xorg.libXrandr
      xorg.libXxf86vm
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXi
    ]
    ++ lib.optionals (openclSupport && !stdenv.isDarwin) [ ocl-icd ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        OpenCL
        Cocoa
        CoreVideo
        IOKit
        AppKit
        AGL
        MetalKit
      ]
    )
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
    ];

  # It's important to set OSD_CUDA_NVCC_FLAGS,
  # because otherwise OSD might piggyback unwanted architectures:
  # https://github.com/PixarAnimationStudios/OpenSubdiv/blob/7d0ab5530feef693ac0a920585b5c663b80773b3/CMakeLists.txt#L602
  preConfigure = lib.optionalString cudaSupport ''
    cmakeFlagsArray+=(
      -DOSD_CUDA_NVCC_FLAGS="${lib.concatStringsSep " " cudaPackages.cudaFlags.gencode}"
    )
  '';

  cmakeFlags =
    [
      "-DNO_TUTORIALS=1"
      "-DNO_REGRESSION=1"
      "-DNO_EXAMPLES=1"
      (lib.cmakeBool "NO_METAL" (!stdenv.isDarwin))
      (lib.cmakeBool "NO_OPENCL" (!openclSupport))
      (lib.cmakeBool "NO_CUDA" (!cudaSupport))
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      "-DGLEW_INCLUDE_DIR=${glew.dev}/include"
      "-DGLEW_LIBRARY=${glew.dev}/lib"
    ]
    ++ lib.optionals cudaSupport [
    ]
    ++ lib.optionals (!openclSupport) [
    ];

  preBuild =
    let
      maxBuildCores = 16;
    in
    lib.optionalString cudaSupport ''
      # https://github.com/PixarAnimationStudios/OpenSubdiv/issues/1313
      NIX_BUILD_CORES=$(( NIX_BUILD_CORES < ${toString maxBuildCores} ? NIX_BUILD_CORES : ${toString maxBuildCores} ))
    '';

  postInstall = ''
    moveToOutput "lib/*.a" $static
  '';

  meta = {
    description = "An Open-Source subdivision surface library";
    homepage = "http://graphics.pixar.com/opensubdiv";
    broken = openclSupport && cudaSupport;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.asl20;
  };
}
