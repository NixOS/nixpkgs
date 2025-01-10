{
  backendStdenv,
  cmake,
  cuda_cccl ? null,
  cuda_nvrtc ? null,
  cuda_nvtx ? null,
  cuda_opencl ? null,
  cudaAtLeast,
  cudaOlder,
  lib,
  libcublas ? null,
  libcufft ? null,
  libcurand ? null,
  libcusolver ? null,
  libcusparse ? null,
  libnpp ? null,
  libnvjitlink ? null,
  testCudaPackageType,
}:
let
  inherit (lib.asserts) assertMsg;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) elem optionals;
  inherit (lib.strings) versionAtLeast;
  inherit (lib.trivial) id const;
  inherit (backendStdenv.cc) isClang;
  optional = cond: if cond then id else const null;

  Tests = {
    # The selection logic comes from Tests/Cuda/CMakeLists.txt.
    Cuda = {
      # Complex = {}; # TODO(@connorbaker): Why does this fail with "error while loading shared libraries: libcudart.so.12: cannot open shared object file: No such file or directory"?
      CXXStandardSetTwice = { };
      IncludePathNoToolkit = { };
      MixedStandardLevels1 = { };
      MixedStandardLevels2 = { };
      MixedStandardLevels3 = { };
      ${optional (!isClang) "MixedStandardLevels4"} = { };
      ${optional (!isClang) "MixedStandardLevels5"} = { };
      NotEnabled = { };
      ObjectLibrary = { };
      ${optional (!isClang) "ProperDeviceLibraries"} = {
        extraBuildInputs = optionals (testCudaPackageType == "redist") (
          [ libcublas ] ++ optionals (cudaAtLeast "12.0") [ cuda_cccl ]
        );
        extraBrokenConditions = {
          "testCudaPackageType 'redist' requires libcublas" =
            testCudaPackageType == "redist" && libcublas == null;
          "testCudaPackageType 'redist' with CUDA 12.0+ requires cuda_cccl" =
            testCudaPackageType == "redist" && (cudaAtLeast "12.0") && cuda_cccl == null;
        };
      };
      ProperLinkFlags = { };
      SeparableCompCXXOnly = { };
      SharedRuntimePlusToolkit = {
        extraBuildInputs = optionals (testCudaPackageType == "redist") [
          libcurand
          libnpp
        ];
        extraBrokenConditions = {
          "testCudaPackageType 'redist' requires libcurand" =
            testCudaPackageType == "redist" && libcurand == null;
          "testCudaPackageType 'redist' requires libnpp" = testCudaPackageType == "redist" && libnpp == null;
        };
      };
      StaticRuntimePlusToolkit = {
        extraBuildInputs = optionals (testCudaPackageType == "redist") [
          libcurand
          libnpp
        ];
        extraBrokenConditions = {
          "testCudaPackageType 'redist' requires libcurand" =
            testCudaPackageType == "redist" && libcurand == null;
          "testCudaPackageType 'redist' requires libnpp" = testCudaPackageType == "redist" && libnpp == null;
        };
      };
      StubRPATH = { };
      Toolkit = {
        extraBuildInputs = optionals (testCudaPackageType == "redist") (
          [
            cuda_nvrtc
            cuda_nvtx
            libcublas
            libcufft
            libcurand
            libcusolver
            libcusparse
            libnpp
          ]
          ++ optionals (cudaAtLeast "12.0") [
            cuda_opencl
            libnvjitlink
          ]
        );
        extraBrokenConditions = {
          # TODO: Figure out why CMake requires cuda_opencl even when it appears to be new to CUDA 12.0.
          "testCudaPackageType 'cudatoolkit' does not provide cuda_opencl prior to CUDA 12.0" =
            testCudaPackageType == "cudatoolkit" && cudaOlder "12.0";
          # TODO: Figure out why cudatoolkit-legacy-runfile doesn't seem to provide cuda_opencl at all.
          "testCudaPackageType 'cudatoolkit-legacy-runfile' does not provide cuda_opencl" =
            testCudaPackageType == "cudatoolkit-legacy-runfile";
          "testCudaPackageType 'redist' requires cuda_nvrtc" =
            testCudaPackageType == "redist" && cuda_nvrtc == null;
          "testCudaPackageType 'redist' requires cuda_nvtx" =
            testCudaPackageType == "redist" && cuda_nvtx == null;
          "testCudaPackageType 'redist' requires libcublas" =
            testCudaPackageType == "redist" && libcublas == null;
          "testCudaPackageType 'redist' requires libcufft" =
            testCudaPackageType == "redist" && libcufft == null;
          "testCudaPackageType 'redist' requires libcurand" =
            testCudaPackageType == "redist" && libcurand == null;
          "testCudaPackageType 'redist' requires libcusolver" =
            testCudaPackageType == "redist" && libcusolver == null;
          "testCudaPackageType 'redist' requires libcusparse" =
            testCudaPackageType == "redist" && libcusparse == null;
          "testCudaPackageType 'redist' requires libnpp" = testCudaPackageType == "redist" && libnpp == null;
          "testCudaPackageType 'redist' with CUDA 12.0+ requires cuda_opencl" =
            testCudaPackageType == "redist" && (cudaAtLeast "12.0") && cuda_opencl == null;
          "testCudaPackageType 'redist' with CUDA 12.0+ requires libnvjitlink" =
            testCudaPackageType == "redist" && (cudaAtLeast "12.0") && libnvjitlink == null;
        };
      };
      ${optional (!isClang && versionAtLeast cmake.version "3.30.0") "ToolkitBeforeLang"} = { };
      WithC = { };
    };
    # NOTE: While CudaOnly contains strictly CUDA files, some tests must have CXX enabled in order for
    # find_package(CUDA) or find_package(CUDAToolkit) to work, as some codepaths invoke find_package(Threads),
    # which requires CXX to be enabled.
    CudaOnly = {
      Architecture = { };
      # "ArchSpecial" # TODO: Architectures used for "native" don't match the reference ("52" != "No CUDA devices found.").
      CircularLinkLine = { };
      CompileFlags = { };
      # ${optional (!isClang) "CUBIN"} = {}; # TODO: make: *** No rule to make target 'install'.  Stop.
      # DeviceLTO = { }; # TODO: Fix this. Broken on 11.5 with at least redist.
      DontResolveDeviceSymbols = { }; # TODO: Additional arguments to add
      EnableStandard = { };
      ExportPTX.enableCXX = true;
      ${optional (!isClang) "Fatbin"}.enableCXX = true;
      ${optional (!isClang) "GPUDebugFlag"} = { };
      # ${optional (!isClang) "OptixIR"}.enableCXX = true; # TODO: Fix this. Broken on 11.4/5 with at least redist.
      # "PDB" # NOTE: Only availble on Windows MSVC
      ResolveDeviceSymbols = { };
      RuntimeControls = { }; # TODO: Additional arguments to add
      SeparateCompilation = { };
      # SeparateCompilationPTX.enableCXX = true; # TODO: Fix this. Broken 11.4+ with at least redist.
      SeparateCompilationTargetObjects = { };
      SharedRuntimePlusToolkit = Tests.Cuda.SharedRuntimePlusToolkit // {
        enableCXX = true;
      };
      ${optional (!isClang) "SharedRuntimeViaCUDAFlags"}.enableCXX = true;
      ${optional (!isClang) "Standard98"} = { };
      StaticRuntimePlusToolkit = Tests.Cuda.StaticRuntimePlusToolkit // {
        enableCXX = true;
      };
      Toolkit = Tests.Cuda.Toolkit // {
        enableCXX = true;
      };
      ToolkitBeforeLang = { };
      ToolkitMultipleDirs.enableCXX = true;
      TryCompileTargetStatic = { };
      WithDefs = { };
    };
  };
in
assert assertMsg (elem testCudaPackageType [
  "redist"
  "cudatoolkit"
  "cudatoolkit-legacy-runfile"
]) "testCudaPackageType must be one of 'redist', 'cudatoolkit', or 'cudatoolkit-legacy-runfile'";
{
  inherit Tests;
}
