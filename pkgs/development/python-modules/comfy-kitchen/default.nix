{
  lib,
  buildPythonPackage,
  cmake,
  config,
  cudaSupport ? config.cudaSupport,
  fetchFromGitHub,
  nanobind,
  ninja,
  setuptools,
  torch,
  comfyui,
}:

let
  inherit (torch) cudaPackages;
in
buildPythonPackage (finalAttrs: {
  pname = "comfy-kitchen";
  version = "0.2.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-kitchen";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-apa7N9Y0bt4fpbMTP0qRUC0QnMuJvoxoCOeWONWCExo=";
  };

  buildInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart
      libcublas
    ]
  );

  build-system = [
    cmake
    nanobind
    ninja
    setuptools
  ];

  dependencies = [ torch ];

  dontUseCmakeConfigure = true;

  pypaBuildFlags =
    if cudaSupport then
      [
        ''--config-setting=--cuda-archs="${
          lib.concatMapStringsSep ";" cudaPackages.flags.dropDots torch.cudaCapabilities
        }"''
      ]
    else
      [ "-C--global-option=--no-cuda" ];

  env = lib.optionalAttrs cudaSupport {
    CUDA_HOME = cudaPackages.cuda_nvcc;
  };

  # Upstream tests exercise the CUDA/Triton kernel backends; this build
  # might use BUILD_NO_CUDA = True, so those backends would be unavailable
  # and additionally the nix sandbox would prevent it.
  doCheck = false;

  pythonImportsCheck = [ "comfy_kitchen" ];

  meta = {
    description = "Fast kernel library for ComfyUI with multiple compute backends";
    homepage = "https://github.com/Comfy-Org/comfy-kitchen";
    license = lib.licenses.asl20;
    inherit (comfyui.meta) maintainers;
  };
})
