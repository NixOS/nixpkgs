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
  targetLlvm,
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
  fetchpatch,
}:

assert lib.assertMsg (ompdGdbSupport -> ompdSupport) "OMPD GDB support requires OMPD support!";

stdenv.mkDerivation (
  finalAttrs:
  {
    pname = "openmp";
    inherit version;

    src =
      if monorepoSrc != null then
        runCommand "openmp-src-${version}" { inherit (monorepoSrc) passthru; } (
          ''
            mkdir -p "$out"
          ''
          + lib.optionalString (lib.versionAtLeast release_version "14") ''
            cp -r ${monorepoSrc}/cmake "$out"
          ''
          + ''
            cp -r ${monorepoSrc}/openmp "$out"
          ''
        )
      else
        src;

    sourceRoot = "${finalAttrs.src.name}/openmp";

    outputs = [ "out" ] ++ lib.optionals (lib.versionAtLeast release_version "14") [ "dev" ];

    patchFlags = if lib.versionOlder release_version "14" then [ "-p2" ] else null;

    patches =
      lib.optional (lib.versionAtLeast release_version "15" && lib.versionOlder release_version "19") (
        getVersionFile "openmp/fix-find-tool.patch"
      )
      ++ lib.optional (lib.versionAtLeast release_version "14" && lib.versionOlder release_version "18") (
        getVersionFile "openmp/gnu-install-dirs.patch"
      )
      ++ lib.optional (lib.versionAtLeast release_version "14") (
        getVersionFile "openmp/run-lit-directly.patch"
      )
      ++
        lib.optional (lib.versionOlder release_version "14")
          # Fix cross.
          (
            fetchpatch {
              url = "https://github.com/llvm/llvm-project/commit/5e2358c781b85a18d1463fd924d2741d4ae5e42e.patch";
              hash = "sha256-UxIlAifXnexF/MaraPW0Ut6q+sf3e7y1fMdEv1q103A=";
            }
          );

    nativeBuildInputs = [
      cmake
      python3.pythonOnBuildForHost
      perl
    ]
    ++ lib.optionals (lib.versionAtLeast release_version "15") [
      ninja
    ]
    ++ lib.optionals (lib.versionAtLeast release_version "14") [
      pkg-config
      lit
    ];

    buildInputs = [
      (if stdenv.buildPlatform == stdenv.hostPlatform then llvm else targetLlvm)
    ]
    ++ lib.optionals (ompdSupport && ompdGdbSupport) [
      python3
    ];

    cmakeFlags = [
      (lib.cmakeBool "LIBOMP_ENABLE_SHARED" (
        !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.hasSharedLibraries
      ))
      (lib.cmakeBool "LIBOMP_OMPD_SUPPORT" ompdSupport)
      (lib.cmakeBool "LIBOMP_OMPD_GDB_SUPPORT" ompdGdbSupport)
    ]
    ++ lib.optionals (lib.versions.major release_version == "13") [
      (lib.cmakeBool "LIBOMPTARGET_BUILD_AMDGCN_BCLIB" false) # Building the AMDGCN device RTL fails
    ]
    ++ lib.optionals (lib.versionAtLeast release_version "14") [
      (lib.cmakeFeature "CLANG_TOOL" "${clang-unwrapped}/bin/clang")
      (lib.cmakeFeature "OPT_TOOL" "${llvm}/bin/opt")
      (lib.cmakeFeature "LINK_TOOL" "${llvm}/bin/llvm-link")
    ]
    ++ devExtraCmakeFlags;

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
  // (lib.optionalAttrs (lib.versionAtLeast release_version "14") {
    doCheck = false;
    checkTarget = "check-openmp";
    preCheck = ''
      patchShebangs ../tools/archer/tests/deflake.bash
    '';
  })
)
