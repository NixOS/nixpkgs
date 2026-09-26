{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  torch,
  triton,
}:

buildPythonPackage (finalAttrs: {
  pname = "liger-kernel";
  version = "0.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linkedin";
    repo = "liger-kernel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rJHBX96ly/U3h/XwbYUP+JQYEDt4wUHVCHkYzCS9hcM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    torch
    triton
  ];

  # Requires NVIDIA driver.
  doCheck = false;

  pythonImportsCheck = [ "liger_kernel" ];

  meta = {
    description = "Efficient Triton Kernels for LLM Training";
    homepage = "https://github.com/linkedin/liger-kernel";
    changelog = "https://github.com/linkedin/liger-kernel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
