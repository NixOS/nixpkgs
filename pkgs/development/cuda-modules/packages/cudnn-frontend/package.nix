{
  autoAddDriverRunpath,
  backendStdenv,
  catch2_3,
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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cudnn-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vc5jqB1XHcJEdKG0nxbWLewW2fDezRVwjUSzPDubSGE=";
  };

  patches = [
    # https://github.com/NVIDIA/cudnn-frontend/pull/125
    ./0001-cmake-float-out-common-python-bindings-option.patch
    ./0002-cmake-add-config-so-headers-can-be-discovered-when-i.patch
    ./0003-cmake-install-samples-and-tests-when-built.patch
    ./0004-samples-fix-instances-of-maybe-uninitialized.patch
  ];

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
    catch2_3
    libcublas
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    nlohmann_json
  ];

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
    # TODO(@connorbaker): How tightly coupled is this library to specific cuDNN versions?
    # Should it be marked as broken if it doesn't match our expected version?
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ maintainers.connorbaker ];
    teams = [ teams.cuda ];
  };
})
