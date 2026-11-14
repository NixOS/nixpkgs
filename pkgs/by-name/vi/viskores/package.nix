{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  ninja,
  llvmPackages,
  onetbb,
  mpi,
  mpiSupport ? true,
  kokkos,
  viskores,
  # The GPU backend follows kokkos, e.g. HIP when built with rocmSupport
  kokkosSupport ? false,
  testers,
}:
let
  hipSupport = kokkosSupport && kokkos.rocmSupport;
  stdenv' = if hipSupport then kokkos.rocmPackages.stdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "viskores";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "viskores";
    repo = "viskores";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fD0L+offvoeYa2yuJ828VRa4GA9/PiyXmxrFAei7u2w=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    onetbb
  ]
  ++ lib.optional mpiSupport mpi
  ++ lib.optional kokkosSupport kokkos
  ++ lib.optional (stdenv.cc.isClang && !hipSupport) llvmPackages.openmp;

  cmakeFlags = [
    # The HIP build compiles every source with the unwrapped hipClang, which does
    # not see omp.h from the OpenMP package; the Kokkos HIP device covers it instead
    (lib.cmakeBool "Viskores_ENABLE_OPENMP" (!hipSupport))
    (lib.cmakeBool "Viskores_ENABLE_TBB" true)
    (lib.cmakeBool "Viskores_ENABLE_MPI" mpiSupport)
    (lib.cmakeBool "Viskores_USE_DEFAULT_TYPES_FOR_VTK" true)
    (lib.cmakeFeature "Viskores_INSTALL_INCLUDE_DIR" "include")
    (lib.cmakeFeature "Viskores_INSTALL_CONFIG_DIR" "lib/cmake/viskores")
    (lib.cmakeFeature "Viskores_INSTALL_SHARE_DIR" "share/viskores")
  ]
  ++ lib.optionals kokkosSupport [
    (lib.cmakeBool "Viskores_ENABLE_KOKKOS" true)
  ]
  ++ lib.optionals hipSupport [
    (lib.cmakeFeature "CMAKE_HIP_COMPILER" "${kokkos.rocmPackages.clr.hipClangPath}/clang++")
    (lib.cmakeFeature "CMAKE_HIP_COMPILER_ROCM_ROOT" "${kokkos.rocmPackages.clr}")
    (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" kokkos.hipTarget)
  ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "Viskores" ];
      package = finalAttrs.finalPackage;
    };
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) {
    # Build smoke test only: running HIP kernels needs a GPU.
    # There is no finalAttrs.finalPackage.override, so the package refers to itself.
    kokkos-rocm = viskores.override {
      kokkosSupport = true;
      kokkos = kokkos.override {
        rocmSupport = true;
        hipTarget = "gfx1100";
      };
    };
  };

  meta = {
    description = "Visualization library for many-threaded devices";
    homepage = "https://github.com/Viskores/viskores";
    changelog = "https://github.com/Viskores/viskores/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
