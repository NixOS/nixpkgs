{
  lib,
  buildPythonPackage,
  fetchPypi,
  nvidia-cutlass-dsl-libs-base,

  # dependencies
  cuda-bindings,
  numpy,
  protobuf,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-dsl-libs-core";
  inherit (nvidia-cutlass-dsl-libs-base) version;
  format = "wheel";
  __structuredAttrs = true;

  # Universal metadata-only wheel that just pulls in `nvidia-cutlass-dsl-libs-base`
  # (which actually ships the Python code and the bundled MLIR/CUDA runtime libs).
  src = fetchPypi {
    pname = "nvidia_cutlass_dsl_libs_core";
    inherit (finalAttrs) version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = "sha256-PGoSjOMUrKPzMuq8sOVaLEw6qVHjNlhKeusrATvtRHQ=";
  };

  pythonRemoveDeps = [
    # Only cuda-bindings is needed
    "cuda-python"

    # just a wrapper for cudaPackages.cuda_nvdisasm
    "nvidia-cuda-nvdisasm"
  ];
  pythonRelaxDeps = [
    "protobuf"
  ];
  dependencies = [
    cuda-bindings
    numpy
    protobuf
    typing-extensions
  ];

  # No tests in the Pypi archive
  doCheck = false;

  meta = {
    description = "NVIDIA CUTLASS Python DSL";
    homepage = "https://github.com/NVIDIA/cutlass";
    changelog = "https://github.com/NVIDIA/cutlass/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.unfreeRedistributable; # NVIDIA Proprietary
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
