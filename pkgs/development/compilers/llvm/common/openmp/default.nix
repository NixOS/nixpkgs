{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  monorepoSrc ? null,
  src ? null,
  runCommand,
  cmake,
  ninja,
  llvm,
  lit,
  clang-unwrapped,
  perl,
  pkg-config,
  python3,
  version,
  devExtraCmakeFlags ? [ ],
  ompdSupport ? true,
  ompdGdbSupport ? ompdSupport,
  getVersionFile,
  checkPhaseThreadLimitHook,
}:

assert lib.assertMsg (ompdGdbSupport -> ompdSupport) "OMPD GDB support requires OMPD support!";

stdenv.mkDerivation (finalAttrs: {
  pname = "openmp";
  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "openmp-src-${version}"
        {
          inherit (monorepoSrc) passthru;
          strictDeps = true;
          __structuredAttrs = true;
        }
        (
          ''
            mkdir -p "$out"
            cp -r ${monorepoSrc}/cmake "$out"
            cp -r ${monorepoSrc}/openmp "$out"
          ''
          + lib.optionalString (lib.versionAtLeast release_version "23") ''
            mkdir -p "$out/llvm"
            cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
            cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
            cp -r ${monorepoSrc}/third-party "$out"
            cp -r ${monorepoSrc}/runtimes "$out"
          ''
        )
    else
      src;

  # LLVM 23 removed OpenMP's standalone build
  # https://openmp.llvm.org/Building.html
  sourceRoot =
    "${finalAttrs.src.name}/"
    + (if lib.versionAtLeast release_version "23" then "runtimes" else "openmp");

  outputs = [
    "out"
    "dev"
  ];

  patches =
    lib.optional (lib.versionOlder release_version "19") (getVersionFile "openmp/fix-find-tool.patch")
    ++ [
      (getVersionFile "openmp/run-lit-directly.patch")
    ];

  nativeBuildInputs = [
    cmake
    python3
    perl
    ninja
    pkg-config
    lit
  ];

  propagatedNativeBuildInputs = [
    checkPhaseThreadLimitHook
  ];

  buildInputs = [
    llvm
  ]
  ++ lib.optionals (ompdSupport && ompdGdbSupport) [
    python3
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "LIBOMP_ENABLE_SHARED" (
      !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.hasSharedLibraries
    ))
    (lib.cmakeBool "LIBOMP_OMPD_SUPPORT" ompdSupport)
    (lib.cmakeBool "LIBOMP_OMPD_GDB_SUPPORT" ompdGdbSupport)
    (lib.cmakeFeature "CLANG_TOOL" "${clang-unwrapped}/bin/clang")
    (lib.cmakeFeature "OPT_TOOL" "${llvm}/bin/opt")
    (lib.cmakeFeature "LINK_TOOL" "${llvm}/bin/llvm-link")
  ]
  ++ lib.optionals (lib.versionAtLeast release_version "23") [
    (lib.cmakeFeature "LLVM_ENABLE_RUNTIMES" "openmp")
  ]
  ++ devExtraCmakeFlags;

  doCheck = false;

  checkTarget = "check-openmp";

  preCheck = ''
    patchShebangs ${
      if lib.versionAtLeast release_version "23" then "../../openmp" else ".."
    }/tools/archer/tests/deflake.bash
  '';

  __structuredAttrs = true;

  meta = llvm_meta // {
    homepage = "https://openmp.llvm.org/";
    description = "Support for the OpenMP language";
    longDescription = ''
      The OpenMP subproject of LLVM contains the components required to build an
      executable OpenMP program that are outside the compiler itself.
      Contains the code for the runtime library against which code compiled by
      "clang -fopenmp" must be linked before it can run and the library that
      supports offload to target devices.
    '';
    # "All of the code is dual licensed under the MIT license and the UIUC
    # License (a BSD-like license)":
    license = with lib.licenses; [
      mit
      ncsa
    ];
  };
})
