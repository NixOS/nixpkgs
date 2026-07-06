{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  apache-tvm-ffi,
  cuda-bindings,
  einops,
  nvidia-cutlass-dsl,
  quack-kernels,
  torch,
  torch-c-dlpack-ext,
}:
buildPythonPackage (finalAttrs: {
  pname = "flash-attn-4";
  version = "4.0.0.beta15";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    tag = "fa4-v${finalAttrs.version}";
    hash = "sha256-k6158mEJocKIRS4MQIM+Ih4VMHnXCKJGcykZFi91J2w=";
  };

  # FA4 is a separate distribution shipped under flash_attn/cute/ with its own pyproject.toml.
  # The top-level setup.py builds the classic compiled flash-attn and excludes flash_attn.cute.
  sourceRoot = "${finalAttrs.src.name}/flash_attn/cute";

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    apache-tvm-ffi
    cuda-bindings
    einops
    nvidia-cutlass-dsl
    quack-kernels
    torch
    torch-c-dlpack-ext
  ];

  pythonImportsCheck = [ "flash_attn.cute" ];

  # No tests
  doCheck = false;

  meta = {
    description = "CuTeDSL-based implementation of FlashAttention for Hopper and Blackwell GPUs";
    homepage = "https://github.com/Dao-AILab/flash-attention/tree/main/flash_attn/cute";
    changelog = "https://github.com/Dao-AILab/flash-attention/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      prince213
    ];
  };
})
