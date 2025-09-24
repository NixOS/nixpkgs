{
  autoAddDriverRunpath,
  catch2_3,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  lib,
  ninja,
  nlohmann_json,
  stdenv,
  cuda_cccl ? null,
  cuda_cudart ? null,
  cuda_nvcc ? null,
  cuda_nvrtc ? null,
  cudnn ? null,
  libcublas ? null,
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.strings)
    cmakeBool
    cmakeFeature
    optionalString
    ;
in

# TODO(@connorbaker): This should be a hybrid C++/Python package.
stdenv.mkDerivation (finalAttrs: {
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
    echo "patching source to use nlohmann_json from nixpkgs"
    rm -rf include/cudnn_frontend/thirdparty/nlohmann
    rmdir include/cudnn_frontend/thirdparty
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
    license = lib.licenses.mit;
    badPlatforms = optionals (cudnn == null) finalAttrs.meta.platforms;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
  };
})
