{ config, lib, stdenv, fetchFromGitHub, cmake, pkg-config, xorg, libGLU
, libGL, glew, ocl-icd, python3
, cudaSupport ? config.cudaSupport or false, cudatoolkit
  # For visibility mostly. The whole approach to cuda architectures and capabilities
  # will be reworked soon.
, cudaArch ? "compute_37"
, openclSupport ? !cudaSupport
, darwin
}:

stdenv.mkDerivation rec {
  pname = "opensubdiv";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenSubdiv";
    rev = "v${lib.replaceChars ["."] ["_"] version}";
    sha256 = "sha256-ejxQ5mGIIrEa/rAfkTrRbIRerrAvEPoWn7e0lIqS1JQ=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs =
    [ libGLU libGL python3
      # FIXME: these are not actually needed, but the configure script wants them.
      glew xorg.libX11 xorg.libXrandr xorg.libXxf86vm xorg.libXcursor
      xorg.libXinerama xorg.libXi
    ]
    ++ lib.optional (openclSupport && !stdenv.isDarwin) ocl-icd
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [OpenCL Cocoa CoreVideo IOKit AppKit AGL ])
    ++ lib.optional cudaSupport cudatoolkit;

  cmakeFlags =
    [ "-DNO_TUTORIALS=1"
      "-DNO_REGRESSION=1"
      "-DNO_EXAMPLES=1"
      "-DNO_METAL=1" # don’t have metal in apple sdk
    ] ++ lib.optionals (!stdenv.isDarwin) [
      "-DGLEW_INCLUDE_DIR=${glew.dev}/include"
      "-DGLEW_LIBRARY=${glew.dev}/lib"
    ] ++ lib.optionals cudaSupport [
      "-DOSD_CUDA_NVCC_FLAGS=--gpu-architecture=${cudaArch}"
      "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
    ] ++ lib.optionals (!openclSupport) [
      "-DNO_OPENCL=1"
    ];

  postInstall = "rm $out/lib/*.a";

  meta = {
    description = "An Open-Source subdivision surface library";
    homepage = "http://graphics.pixar.com/opensubdiv";
    broken = openclSupport && cudaSupport;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.asl20;
  };
}
