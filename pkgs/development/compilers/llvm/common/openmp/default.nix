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

let
  # LLVM 23 removed the legacy standalone OpenMP build (cmake <llvm>/openmp now
  # aborts with a FATAL_ERROR). OpenMP must be built through the runtimes entry
  # point (cmake <llvm>/runtimes -DLLVM_ENABLE_RUNTIMES=openmp), which supplies
  # the project() call and the LLVM cmake modules. Older LLVMs keep the
  # standalone layout.
  useRuntimesBuild = lib.versionAtLeast release_version "23";
in
stdenv.mkDerivation (
  finalAttrs:
  {
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
            if useRuntimesBuild then
              ''
                mkdir -p "$out/llvm"
                cp -r ${monorepoSrc}/cmake "$out"
                cp -r ${monorepoSrc}/runtimes "$out"
                cp -r ${monorepoSrc}/openmp "$out"
                cp -r ${monorepoSrc}/llvm/cmake "$out/llvm/"
                # openmp/runtime/unittests unconditionally pulls in gtest from
                # ../third-party/unittest, so it must be present even with tests off.
                cp -r ${monorepoSrc}/third-party "$out"
              ''
            else
              ''
                mkdir -p "$out"
                cp -r ${monorepoSrc}/cmake "$out"
                cp -r ${monorepoSrc}/openmp "$out"
              ''
          )
      else
        src;

    sourceRoot = "${finalAttrs.src.name}/${if useRuntimesBuild then "runtimes" else "openmp"}";

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
    ++ lib.optionals useRuntimesBuild [
      # Build through the runtimes entry point (see useRuntimesBuild above).
      (lib.cmakeFeature "LLVM_ENABLE_RUNTIMES" "openmp")
      # We disable tests (doCheck = false); avoid pulling in third-party/unittest,
      # which the trimmed source tree does not contain.
      (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
    ]
    ++ devExtraCmakeFlags;

    doCheck = false;

    checkTarget = "check-openmp";

    preCheck = ''
      patchShebangs ../tools/archer/tests/deflake.bash
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
  }
  # Kept conditional so that derivations for older LLVMs stay unchanged.
  // lib.optionalAttrs useRuntimesBuild {
    # The runtimes build writes generated headers (omp.h, ...) back into the
    # openmp/ source tree, which is a sibling of sourceRoot and therefore left
    # read-only by unpackPhase (only sourceRoot gets `chmod u+w`). Make the whole
    # checkout writable.
    preConfigure = ''
      chmod -R u+w ..
    '';
  }
)
