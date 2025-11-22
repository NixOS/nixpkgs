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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "viskores";
    repo = "viskores";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s399ZkUlKB1xvow+VcA3FQxd+GVlCJyx6KWLtl2Z3RY=";
  };

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
