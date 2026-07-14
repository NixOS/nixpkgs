{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  torch,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvidia-dlfw-inspect";
  version = "0.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-dlfw-inspect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CYhytl6z/XajR613/N5x3ztNEzI8+HUKfw+9qCKZGJI=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    torch
  ];

  pythonImportsCheck = [
    "nvdlfw_inspect"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Debugging and inspection tool for deep learning frameworks including Transformer Engine, Megatron-LM, and NeMo";
    homepage = "https://github.com/NVIDIA/nvidia-dlfw-inspect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
