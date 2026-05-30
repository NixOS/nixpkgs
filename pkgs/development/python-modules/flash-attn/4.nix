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
  pname = "flash-attention-4";
  version = "4.0.0.beta15";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    tag = "fa4-v${finalAttrs.version}";
    hash = "sha256-k6158mEJocKIRS4MQIM+Ih4VMHnXCKJGcykZFi91J2w=";
  };

  sourceRoot = "${finalAttrs.src.name}/flash_attn/cute";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    # Used in flash_attn/cute/interface.py
    cuda-bindings

    apache-tvm-ffi
    einops
    nvidia-cutlass-dsl
    quack-kernels
    torch
    torch-c-dlpack-ext
  ];

  pythonImportsCheck = [ "flash_attn.cute" ];

  # no tests
  doCheck = false;

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  meta = {
    description = "Official implementation of FlashAttention and FlashAttention-2";
    homepage = "https://github.com/Dao-AILab/flash-attention";
    changelog = "https://github.com/Dao-AILab/flash-attention/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
