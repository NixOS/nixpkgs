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
    optionalString
    ;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";

  pname = "cudnn-frontend";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cudnn-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zUCrLJvkqw2FUgBR2mDwaqnmyQ21xuexNJb1omgbJRw=";
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
