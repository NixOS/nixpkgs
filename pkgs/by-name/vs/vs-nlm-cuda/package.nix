{
  lib,
  gcc12Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cudaPackages_11_8,
  vapoursynth,
  zimg,
}:

gcc12Stdenv.mkDerivation (finalAttrs: {
  pname = "vs-nlm-cuda";
  version = "1";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-nlm-cuda";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-VxIe3ec0Hxgcd6HTDbZ9zx6Ss0H2eOtRVLq1ftIwRPY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    cudaPackages_11_8.cuda_nvcc
    cudaPackages_11_8.cuda_nvrtc
  ];

  buildInputs = [
    cudaPackages_11_8.cuda_cudart
    vapoursynth
    zimg
  ];

  preConfigure = ''
    cmakeFlagsArray=(${lib.escapeShellArg (lib.cmakeFeature "CMAKE_CUDA_FLAGS" "--use_fast_math -Wno-deprecated-gpu-targets")})
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${VS_LIBDIR}" "lib"
  '';

  meta = {
    description = "Plugin for VapourSynth: vs-nlm-cuda";
    homepage = "https://github.com/AmusementClub/vs-nlm-cuda";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.all;
  };
})
