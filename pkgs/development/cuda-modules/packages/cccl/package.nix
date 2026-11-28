{
  backendStdenv,
  callPackage,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  manifests,
  markForCudatoolkitRootHook,
}:
let
  inherit (lib.strings) cmakeBool cmakeFeature;

  # NVIDIA renamed cuda_cccl to cccl in CUDA 13.3.
  redist = manifests.cuda.cccl or manifests.cuda.cuda_cccl;

  release =
    (import ./releases.nix { inherit fetchpatch; }).${redist.version}
      or (throw "cudaPackages.cccl: no CCCL release is known for the ${redist.version} redistributable; add it to releases.nix");
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "cccl";
  inherit (release) version;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cccl";
    tag = "v${finalAttrs.version}";
    inherit (release) hash;
  };

  patches = release.patches or [ ];

  nativeBuildInputs = [
    cmake
    markForCudatoolkitRootHook
  ];

  # The developer builds need a CUDA compiler, and are enabled by default before CCCL 3.0.
  cmakeFlags = [
    (cmakeBool "CCCL_ENABLE_LIBCUDACXX" false)
    (cmakeBool "CCCL_ENABLE_CUB" false)
    (cmakeBool "CCCL_ENABLE_THRUST" false)
    (cmakeBool "CCCL_ENABLE_EXAMPLES" false)
    # The *-header-search.cmake files append CMAKE_INSTALL_INCLUDEDIR to a path relative to their own directory, so the
    # absolute path set by the CMake setup hook makes find_package fail to locate the headers.
    (cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ]
  # Before CCCL 2.8, the install rules of each library are only enabled with its developer build.
  ++ lib.optionals (lib.versionOlder finalAttrs.version "2.8") [
    (cmakeBool "libcudacxx_ENABLE_INSTALL_RULES" true)
    (cmakeBool "CUB_ENABLE_INSTALL_RULES" true)
    (cmakeBool "THRUST_ENABLE_INSTALL_RULES" true)
  ];

  # CUDA 13 installs CCCL in include/cccl, where projects such as CUTLASS look for it.
  # https://github.com/NVIDIA/cutlass/blob/087c84df83d254b5fb295a7a408f1a1d554085cf/CMakeLists.txt#L773
  postInstall = lib.optionalString (lib.versionAtLeast finalAttrs.version "3") ''
    ln -sv . "$out/include/cccl"
  '';

  passthru.tests.export = callPackage ./tests/export.nix { cccl = finalAttrs.finalPackage; };

  meta = {
    description = "Building blocks that make it easier to write safe and efficient CUDA C++ code";
    longDescription = ''
      The goal of CCCL is to provide CUDA C++ developers with building blocks that make it easier to write safe and
      efficient code.
    '';
    homepage = "https://github.com/NVIDIA/cccl";
    changelog = "https://github.com/NVIDIA/cccl/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      AND [
        (WITH asl20 llvm-exception)
        asl20
        bsd2
        bsd3
        boost
        mit
        ncsa
      ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      _81reap
      GaetanLepage
      connorbaker
    ];
    teams = [ lib.teams.cuda ];
  };
})
