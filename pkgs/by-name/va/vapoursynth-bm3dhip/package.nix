{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  rocmPackages,
  vapoursynth,
  gpuTargets ? [
    "gfx1010"
    "gfx1011"
    "gfx1012"
    "gfx1030"
    "gfx1031"
    "gfx1032"
    "gfx1033"
    "gfx1034"
    "gfx1035"
    "gfx1036"
    "gfx1100"
    "gfx1101"
    "gfx1102"
    "gfx1103"
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-bm3dhip";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = "VapourSynth-BM3DCUDA";
    rev = "refs/tags/R${finalAttrs.version}";
    hash = "sha256-Vcg1RaV0lOMAK0LCAJBMMeeSC0HoKigHwebzH/AcH2g=";
  };

  nativeBuildInputs = [
    cmake
    rocmPackages.clr
  ];

  buildInputs = [ rocmPackages.clr ];

  # Taken from https://github.com/WolframRhodium/VapourSynth-BM3DCUDA/blob/main/.github/workflows/linux.yml
  preConfigure = ''
    cmakeFlagsArray=(
      ${lib.escapeShellArg (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-ffast-math -munsafe-fp-atomics")}
    )
  '';

  cmakeFlags = [
    (lib.cmakeFeature "VAPOURSYNTH_INCLUDE_DIRECTORY" "${vapoursynth}/include/vapoursynth")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib/vapoursynth")
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "hipcc")
    (lib.cmakeFeature "GPU_TARGETS" (lib.concatStringsSep ";" gpuTargets))
    (lib.cmakeBool "ENABLE_CUDA" false)
    (lib.cmakeBool "ENABLE_CPU" false)
    (lib.cmakeBool "ENABLE_HIP" true)
  ];

  meta = {
    description = "Plugin for VapourSynth: bm3dhip";
    homepage = "https://github.com/WolframRhodium/VapourSynth-BM3DCUDA";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.all;
  };
})
