{
  lib,
  gcc12Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cudaPackages_11_8,
  rocmPackages,
  vapoursynth,
  zimg,
  cudaSupport ? false,
  rocmSupport ? false,
  genericVector ? false,
}:

# Based on project's CI
gcc12Stdenv.mkDerivation (finalAttrs: {
  pname = "vs-dfttest2";
  version = "7";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "AmusementClub";
    repo = "vs-dfttest2";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6VFUVdCKSbdhjKBUacQXEN5IyB4crngglAM99h+hGxU=";
  };

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages_11_8.cuda_nvcc
      cudaPackages_11_8.cuda_nvrtc
    ]
    ++ lib.optionals rocmSupport [ rocmPackages.clr ];

  buildInputs =
    [
      vapoursynth
      zimg
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages_11_8.cuda_cudart
      cudaPackages_11_8.libcufft
    ]
    ++ lib.optionals rocmSupport [
      rocmPackages.clr
      rocmPackages.hipfft
    ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-ffast-math")
    (lib.cmakeBool "ENABLE_CUDA" cudaSupport)
    (lib.cmakeBool "ENABLE_HIP" rocmSupport)
    (lib.cmakeBool "ENABLE_CPU" (!genericVector))
    (lib.cmakeBool "ENABLE_GCC" genericVector)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${VS_LIBDIR}" "lib"
  '';

  meta = {
    description = "Plugin for VapourSynth: dfttest2";
    homepage = "https://github.com/AmusementClub/vs-dfttest2";
    license = with lib.licenses; [
      gpl3
      asl20
    ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = with lib.platforms; if genericVector then all else x86_64;
  };
})
