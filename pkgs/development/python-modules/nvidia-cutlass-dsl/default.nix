{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  nvidia-cutlass-dsl-libs-base,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-dsl";
  inherit (nvidia-cutlass-dsl-libs-base) version;
  format = "wheel";

  # Universal metadata-only wheel that just pulls in `nvidia-cutlass-dsl-libs-base`
  # (which actually ships the Python code and the bundled MLIR/CUDA runtime libs).
  src = fetchPypi {
    pname = "nvidia_cutlass_dsl";
    inherit (finalAttrs) version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = "sha256-mN/UD6vGwNthDu6upAPwu54q7AvGma4M30dfpKVHEMo=";
  };

  dependencies = [
    nvidia-cutlass-dsl-libs-base
  ];

  pythonImportsCheck = [ "cutlass" ];

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
