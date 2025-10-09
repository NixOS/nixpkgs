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
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "viskores";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "viskores";
    repo = "viskores";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jKuDM/NPfbMIfNpDNsDpmXdKuVobsr3s9+iht1zBLvI=";
  };

  patches = [
    # https://github.com/Viskores/viskores/pull/137
    (fetchpatch2 {
      url = "https://github.com/Viskores/viskores/commit/36bf609511adb5530e6952bc14daefeafdf4ab11.patch?full_index=1";
      hash = "sha256-SKmgVZhkCk1/X17dLXZ8ceF9Pq1Kkc2sXuFdrvotsdo=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    onetbb
  ]
  ++ lib.optional mpiSupport mpi
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    (lib.cmakeBool "Viskores_ENABLE_OPENMP" true)
    (lib.cmakeBool "Viskores_ENABLE_TBB" true)
    (lib.cmakeBool "Viskores_ENABLE_MPI" mpiSupport)
    (lib.cmakeBool "Viskores_USE_DEFAULT_TYPES_FOR_VTK" true)
    (lib.cmakeFeature "Viskores_INSTALL_INCLUDE_DIR" "include")
    (lib.cmakeFeature "Viskores_INSTALL_CONFIG_DIR" "lib/cmake/viskores")
    (lib.cmakeFeature "Viskores_INSTALL_SHARE_DIR" "share/viskores")
  ];

  passthru.tests.cmake-config = testers.hasCmakeConfigModules {
    moduleNames = [ "Viskores" ];
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Visualization library for many-threaded devices";
    homepage = "https://github.com/Viskores/viskores";
    changelog = "https://github.com/Viskores/viskores/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ bsd3 ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
