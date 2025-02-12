{
  autoAddDriverRunpath,
  catch2_3,
  cmake,
  cudaPackages,
  fetchFromGitHub,
  gitUpdater,
  lib,
  ninja,
  nlohmann_json,
  stdenv,
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.strings)
    cmakeBool
    cmakeFeature
    optionalString
    ;
  inherit (cudaPackages)
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cuda_nvrtc
    cudnn
    libcublas
    ;
in

# TODO(@connorbaker): This should be a hybrid C++/Python package.
stdenv.mkDerivation (finalAttrs: {
  pname = "cudnn-frontend";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cudnn-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hKqIWGxVco1qkKxDZjc+pUisIcYJwFjZobJZg1WgDvY=";
  };

  # TODO: As a header-only library, we should make sure we have an `include` directory or similar which is not a
  # superset of the `out` (`bin`) or `dev` outputs (whih is what the multiple-outputs setup hook does by default).
  outputs =
    [
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
    cuda_cccl
    cuda_nvcc
    ninja
  ];

  buildInputs = [
    cuda_cudart
  ];

  postPatch =
    # nlohmann_json should be the only vendored dependency.
    ''
      echo "patching source to use nlohmann_json from nixpkgs"
      rm -rf include/cudnn_frontend/thirdparty/nlohmann
      rmdir include/cudnn_frontend/thirdparty
      substituteInPlace include/cudnn_frontend_utils.h \
        --replace-fail \
          '#include "cudnn_frontend/thirdparty/nlohmann/json.hpp"' \
          '#include <nlohmann/json.hpp>'
    ''
    # Use our own CMakeLists.txt and add a config to make the include files discoverable
    + ''
      echo "replacing CMakeLists.txt to link against forgotten libraries and install targets"
      rm ./CMakeLists.txt
      install -Dm644 "${./CMakeLists.txt}" ./CMakeLists.txt
      install -Dm644 "${./cudnn_frontend-config.cmake.in}" ./cudnn_frontend-config.cmake.in
    '';

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

  meta = with lib; {
    description = "A c++ wrapper for the cudnn backend API";
    homepage = "https://github.com/NVIDIA/cudnn-frontend";
    license = licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = (with maintainers; [ connorbaker ]) ++ teams.cuda.members;
  };
})
