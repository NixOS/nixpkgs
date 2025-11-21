{
  backendStdenv,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  fetchpatch2,
  flags,
  lib,
  srcOnly,
  stdenv,
  stdenvNoCC,
}:
let
  inherit (backendStdenv) cc;
  inherit (lib.attrsets) mapAttrs optionalAttrs recurseIntoAttrs;
  inherit (lib.fixedPoints) composeExtensions toExtension;
  inherit (lib.lists) optionals;
  inherit (lib.strings)
    cmakeBool
    cmakeFeature
    optionalString
    versionAtLeast
    ;

  cmake' = cmake.overrideAttrs (prevAttrs: {
    patches = prevAttrs.patches or [ ] ++ [
      # Fix errors during configuration when C/CXX is not loaded
      # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/10354
      (fetchpatch2 {
        name = "find-cuda-toolkit-check-for-language-enablement.patch";
        url = "https://gitlab.kitware.com/cmake/cmake/-/commit/c5d81a246852e1ad81a3d55fcaff7e6feb779db7.patch";
        hash = "sha256-oGxzbp+x88+79V+Cyx0l7+nMxX+n3ixzAFKPK26NMI8=";
      })
      # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/10289
      (fetchpatch2 {
        name = "update-arch-supported-by-cuda-12_8.patch";
        url = "https://gitlab.kitware.com/cmake/cmake/-/commit/a745b6869ee3681e39544d96d936c95c196c7398.patch";
        hash = "sha256-B6ny6AZFIcyFhsEnzNk7+vJTb36HeguM53sk/LCnjS4=";
      })
    ];
  });

  isBroken = _: prevAttrs: {
    meta = prevAttrs.meta or { } // {
      broken = true;
    };
  };

  cmakeSrc = srcOnly {
    name = "cmake-unpacked";
    inherit (cmake) src version;
    stdenv = stdenvNoCC;
  };

  mkTest =
    let
      generic = stdenv.mkDerivation (finalAttrs: {
        __structuredAttrs = true;
        strictDeps = true;

        testSuiteName = builtins.throw "testSuiteName must be set";
        testName = builtins.throw "testName must be set";

        name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
        pname = "tests-cmake-${finalAttrs.testSuiteName}-${finalAttrs.testName}";
        inherit (cmakeSrc) version;

        src = cmakeSrc;

        setSourceRoot = ''
          sourceRoot="$(echo */Tests/${finalAttrs.testSuiteName}/${finalAttrs.testName})"
        '';

        nativeBuildInputs = [
          cmake'
          cuda_nvcc
        ];

        # If our compiler uses C++14, we must modify the CMake files so they don't hardcode C++11.
        # This behavior has only been seen with GCC 14, but it's possible Clang would also require this.
        requireCxxStandard14 = cc.isGNU && versionAtLeast cc.version "14";

        cmakeListsReplacements = optionalAttrs finalAttrs.requireCxxStandard14 {
          "cuda_std_11" = "cuda_std_14";
          "cxx_std_11" = "cxx_std_14";
          "set(CMAKE_CUDA_STANDARD 11)" = "set(CMAKE_CUDA_STANDARD 14)";
          "set(CMAKE_CXX_STANDARD 11)" = "set(CMAKE_CXX_STANDARD 14)";
        };

        prePatch = optionalString finalAttrs.requireCxxStandard14 ''
          for key in "''${!cmakeListsReplacements[@]}"; do
            if grep -q "$key" CMakeLists.txt; then
              nixLog "replacing occurrences of \"$key\" with \"''${cmakeListsReplacements[$key]}\" in $PWD/CMakeLists.txt"
              substituteInPlace CMakeLists.txt --replace-fail "$key" "''${cmakeListsReplacements[$key]}"
            fi
          done
        '';

        buildInputs = [
          cuda_cudart
        ];

        cmakeFlags = [
          (cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
          (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
        ]
        ++ optionals finalAttrs.requireCxxStandard14 [
          (cmakeFeature "CMAKE_CXX_STANDARD" "14")
          (cmakeFeature "CMAKE_CUDA_STANDARD" "14")
        ];

        # The build *is* the check.
        doCheck = false;

        installPhase = ''
          runHook preInstall
          touch "$out"
          runHook postInstall
        '';

        # Don't try to run stuff in the patch phase as the setup hooks will error on empty output.
        dontFixup = true;

        meta = {
          description = "Generic builder for running CMake tests";
          license = lib.licenses.mit;
          maintainers = lib.teams.cuda.members;
          platforms = [
            "aarch64-linux"
            "x86_64-linux"
          ];
        };
      });
    in
    testSuiteName: testName: overrideAttrsArg:
    generic.overrideAttrs (
      composeExtensions (toExtension { inherit testSuiteName testName; }) (toExtension overrideAttrsArg)
    );
in
recurseIntoAttrs (
  mapAttrs (testSuiteName: testSuite: recurseIntoAttrs (mapAttrs (mkTest testSuiteName) testSuite)) {
    # TODO: Handle set(Cuda.Toolkit_BUILD_OPTIONS -DHAS_CUPTI:BOOL=${CMake_TEST_CUDA_CUPTI})
    # from Tests/Cuda/CMakeLists.txt
    Cuda = {
      Complex = { };
      CXXStandardSetTwice = { };
      IncludePathNoToolkit = { };
      MixedStandardLevels1 = { };
      MixedStandardLevels2 = { };
      MixedStandardLevels3 = { };
      MixedStandardLevels4 = if cc.isClang then isBroken else { };
      MixedStandardLevels5 = if cc.isClang then isBroken else { };
      NotEnabled = { };
      ObjectLibrary = { };
      ProperDeviceLibraries =
        if cc.isClang then
          isBroken # Clang lacks __CUDACC_VER*__ defines.
        else
          isBroken; # TODO: Fix
      ProperLinkFlags = { };
      SeparableCompCXXOnly = { };
      SharedRuntimePlusToolkit = isBroken; # TODO: Fix
      StaticRuntimePlusToolkit = isBroken; # TODO: Fix
      StubRPATH = { };
      Toolkit = isBroken; # TODO: Fix
      ToolkitBeforeLang = if cc.isClang then isBroken else { }; # Clang lacks __CUDACC_VER*__ defines.
      WithC = { };
    };
    # TODO: Handle set(CudaOnly.Toolkit_BUILD_OPTIONS -DHAS_CUPTI:BOOL=${CMake_TEST_CUDA_CUPTI})
    # from Tests/CudaOnly/CMakeLists.txt
    CudaOnly = {
      Architecture = { };
      ArchSpecial = isBroken; # Tries to detect the native architecture, which is impure.
      CircularLinkLine = { };
      CompileFlags = { };
      CUBIN = if cc.isClang then isBroken else { }; # Only NVCC defines __CUDACC_DEBUG__ when compiling in debug mode.
      DeviceLTO = isBroken; # TODO: Fix
      DontResolveDeviceSymbols = { };
      EnableStandard = { };
      ExportPTX = { };
      Fatbin = if cc.isClang then isBroken else { }; # Only NVCC defines __CUDACC_DEBUG__ when compiling in debug mode.
      GPUDebugFlag = if cc.isClang then isBroken else { }; # Only NVCC defines __CUDACC_DEBUG__ when compiling in debug mode.
      OptixIR = if cc.isClang then isBroken else { }; # Only NVCC defines __CUDACC_DEBUG__ when compiling in debug mode.
      PDB = isBroken; # Tests for features that only work with MSVC
      ResolveDeviceSymbols = { };
      RuntimeControls = { };
      SeparateCompilation = { };
      SeparateCompilationPTX = isBroken; # TODO: Fix
      SeparateCompilationTargetObjects = { };
      SharedRuntimePlusToolkit = isBroken; # TODO: Fix
      SharedRuntimeViaCUDAFlags = if cc.isClang then isBroken else { }; # Clang doesn't have flags for selecting the runtime.
      Standard98 = if cc.isClang then isBroken else { };
      StaticRuntimePlusToolkit = isBroken; # TODO: Fix
      Toolkit = isBroken; # TODO: Fix
      ToolkitBeforeLang = { };
      ToolkitMultipleDirs = { };
      TryCompileTargetStatic = { };
      Unity = { };
      WithDefs = { };
    };
  }
)
