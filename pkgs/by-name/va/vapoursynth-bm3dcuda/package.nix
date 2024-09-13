{
  lib,
  gcc12Stdenv,
  fetchFromGitHub,
  cmake,
  cudaPackages_12_3,
  vapoursynth,
  cudaSupport ? true,
  cpuSupport ? false,
}:

# gcc13 producdes weird artifacts
gcc12Stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-bm3dcuda";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = "VapourSynth-BM3DCUDA";
    rev = "refs/tags/R${finalAttrs.version}";
    hash = "sha256-Vcg1RaV0lOMAK0LCAJBMMeeSC0HoKigHwebzH/AcH2g=";
  };

  nativeBuildInputs =
    [ cmake ]
    ++ lib.optionals cudaSupport [
      cudaPackages_12_3.cuda_nvcc
      cudaPackages_12_3.cuda_nvrtc
    ];

  buildInputs = lib.optionals cudaSupport [ cudaPackages_12_3.cuda_cudart ];

  # Taken from https://github.com/WolframRhodium/VapourSynth-BM3DCUDA/blob/main/.github/workflows/linux.yml
  preConfigure =
    ''
      cmakeFlagsArray+=(${lib.escapeShellArg (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-ffast-math${lib.optionalString cpuSupport " -march=x86-64-v3"}")})
    ''
    + lib.optionalString cudaSupport ''
      cmakeFlagsArray+=(${lib.escapeShellArg (lib.cmakeFeature "CMAKE_CUDA_FLAGS" "--use_fast_math -Wno-deprecated-gpu-targets")})
    '';

  cmakeFlags = [
    (lib.cmakeFeature "VAPOURSYNTH_INCLUDE_DIRECTORY" "${vapoursynth}/include/vapoursynth")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib/vapoursynth")
    (lib.cmakeBool "ENABLE_CUDA" cudaSupport)
    (lib.cmakeBool "ENABLE_CPU" cpuSupport)
  ];

  meta = {
    description = "Plugin for VapourSynth: bm3dcuda bm3dcpu";
    homepage = "https://github.com/WolframRhodium/VapourSynth-BM3DCUDA";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = with lib.platforms; if cpuSupport then x86_64 else all;
  };
})
