{
  autoAddDriverRunpath,
  backendStdenv,
  catch2,
  cmake,
  cuda_cccl,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvrtc,
  cudaNamePrefix,
  cudnn,
  fetchFromGitHub,
  gitUpdater,
  lib,
  libcublas,
  ninja,
  nlohmann_json,
}:
let
  inherit (lib) licenses maintainers teams;
  inherit (lib.lists) optionals;
  inherit (lib.strings)
    cmakeBool
    cmakeFeature
    optionalString
    ;
in
# TODO(@connorbaker): This should be a hybrid C++/Python package.
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";

  pname = "cudnn-frontend";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cudnn-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+8aBl9dKd2Uz50XoOr91NRyJ4OGJtzfDNNNYGQJ9b94=";
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
  ++ optionals finalAttrs.doCheck [
    "legacy_samples"
    "samples"
    "tests"
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath # Needed for samples because it links against CUDA::cuda_driver
    cmake
    cuda_nvcc
    ninja
  ];

  buildInputs = [
    cuda_cccl
    cuda_cudart
  ];

  cmakeFlags = [
    (cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    (cmakeBool "CUDNN_FRONTEND_BUILD_SAMPLES" finalAttrs.doCheck)
    (cmakeBool "CUDNN_FRONTEND_BUILD_TESTS" finalAttrs.doCheck)
    (cmakeBool "CUDNN_FRONTEND_BUILD_PYTHON_BINDINGS" false)
  ];

  checkInputs = [
    cudnn
    cuda_nvrtc
    catch2
    libcublas
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    nlohmann_json
  ];

  # TODO(@connorbaker): I'm using this incorrectly to build the executables which would allow us to test functionality,
  # rather than to indicate the checkPhase will actually run.
  doCheck = true;

  postInstall = optionalString finalAttrs.doCheck ''
    moveToOutput "bin/legacy_samples" "$legacy_samples"
    moveToOutput "bin/samples" "$samples"
    moveToOutput "bin/tests" "$tests"
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
    description = "A c++ wrapper for the cudnn backend API";
    homepage = "https://github.com/NVIDIA/cudnn-frontend";
    license = licenses.mit;
    # Supports cuDNN 8.5.0 and newer:
    # https://github.com/NVIDIA/cudnn-frontend/blob/11b51e9c5ad6cc71cd66cb873e34bc922d97d547/README.md?plain=1#L32
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ maintainers.connorbaker ];
    teams = [ teams.cuda ];
  };
})
