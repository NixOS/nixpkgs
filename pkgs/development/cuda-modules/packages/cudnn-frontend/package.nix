{
  backendStdenv,
  catch2_3,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvrtc,
  cudaNamePrefix,
  cudnn,
  fetchFromGitHub,
  gitUpdater,
  lib,
  libcublas,
  nlohmann_json,

  withSamples ? true,
  withTests ? true,
}:
let
  inherit (lib) licenses maintainers teams;
  inherit (lib.lists) optionals;
  inherit (lib.strings)
    cmakeBool
    escapeShellArg
    optionalString
    ;
  compileFeatures = "target_compile_features(cudnn_frontend INTERFACE cxx_std_17)";
  linkCudart = "target_link_libraries(cudnn_frontend INTERFACE CUDA::cudart)";
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";

  pname = "cudnn-frontend";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cudnn-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4KDxORr6vJRgJKYrooIILaWMWkGF6ZDuti1QtrzYTfA=";
  };

  # nlohmann_json should be the only vendored dependency.
  postPatch = ''
    nixLog "patching source to use nlohmann_json from nixpkgs"
    rm -rfv include/cudnn_frontend/thirdparty/nlohmann
    rmdir -v include/cudnn_frontend/thirdparty
    substituteInPlace include/cudnn_frontend_utils.h \
      --replace-fail \
        '#include "cudnn_frontend/thirdparty/nlohmann/json.hpp"' \
        '#include <nlohmann/json.hpp>'
  ''
  # Upstream resolves CUDAToolkit at configure time and freezes the result into the exported target
  # as a bare absolute path, while its config file never forwards the dependency. Consumers then
  # inherit a build-machine path -- under Nixpkgs, cuda_nvcc's include, a nativeBuildInput -- instead
  # of resolving the toolkit themselves. Confine the path to the build and export the dependency, so
  # consumers re-run find_package(CUDAToolkit) in their own environment. This matters beyond the
  # closure: on CUDA 12 crt/ lives in cuda_nvcc, and cuda_runtime_api.h includes it, so consumers
  # that do not otherwise pull in the toolkit would fail to compile.
  # NOTE: the multi-line replacements are built as Nix strings with explicit newlines, so the
  # formatter cannot reindent them into the substitution.
  + ''
    nixLog "patching $PWD/CMakeLists.txt to export CUDAToolkit as a dependency rather than a path"
    substituteInPlace ./CMakeLists.txt \
      --replace-fail \
        '    ''${CUDAToolkit_INCLUDE_DIRS}' \
        '    $<BUILD_INTERFACE:''${CUDAToolkit_INCLUDE_DIRS}>' \
      --replace-fail \
        ${escapeShellArg compileFeatures} \
        ${escapeShellArg "${linkCudart}\n${compileFeatures}"}

    nixLog "patching $PWD/cudnn_frontend-config.cmake.in to forward the CUDAToolkit dependency"
    substituteInPlace ./cudnn_frontend-config.cmake.in \
      --replace-fail \
        '@PACKAGE_INIT@' \
        ${escapeShellArg "@PACKAGE_INIT@\n\ninclude(CMakeFindDependencyMacro)\nfind_dependency(CUDAToolkit)"}
  '';

  # TODO: As a header-only library, we should make sure we have an `include` directory or similar which is not a
  # superset of the `out` (`bin`) or `dev` outputs (which is what the multiple-outputs setup hook does by default).
  outputs = [
    "out"
  ]
  ++ optionals withSamples [
    "legacy_samples"
    "samples"
  ]
  ++ optionals withTests [
    "tests"
  ];

  nativeBuildInputs = [
    cmake
    cuda_nvcc
  ];

  buildInputs = [
    cuda_cudart
  ]
  ++ optionals (withSamples || withTests) [
    catch2_3
    cuda_nvrtc
    cudnn
    libcublas
  ];

  cmakeFlags = [
    (cmakeBool "CUDNN_FRONTEND_BUILD_SAMPLES" withSamples)
    (cmakeBool "CUDNN_FRONTEND_BUILD_TESTS" withTests)
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    nlohmann_json
    cuda_nvrtc # nvrtc.h
  ];

  postInstall =
    optionalString withSamples ''
      moveToOutput "bin/legacy_samples" "$legacy_samples"
      moveToOutput "bin/samples" "$samples"
    ''
    + optionalString withTests ''
      moveToOutput "bin/tests" "$tests"
    ''
    + ''
      if [[ -e "$out/bin" ]]
      then
        nixErrorLog "The bin directory in \$out should no longer exist."
        exit 1
      fi
    '';

  passthru.updateScript = gitUpdater {
    inherit (finalAttrs) pname version;
    rev-prefix = "v";
  };

  meta = {
    description = "Python and C++ Graph API with SOTA attention (SDPA / Flash Attention), MoE grouped GEMM fusions, and FP8/MXFP8 kernels for Hopper and Blackwell GPUs";
    homepage = "https://github.com/NVIDIA/cudnn-frontend";
    downloadPage = "https://github.com/NVIDIA/cudnn-frontend/releases";
    changelog = "https://github.com/NVIDIA/cudnn-frontend/releases/tag/${finalAttrs.src.tag}";
    license = licenses.mit;
    # Supports cuDNN 8.5.0 and newer:
    # https://github.com/NVIDIA/cudnn-frontend/blob/v1.24.0/README.md?plain=1#L83
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ maintainers.connorbaker ];
    teams = [ teams.cuda ];
  };
})
