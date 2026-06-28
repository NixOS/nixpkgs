{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  opt-einsum,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "opt-einsum-fx";
  version = "0.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Linux-cpp-lisp";
    repo = "opt_einsum_fx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HamDghqmdX4Q+4zXQvCly588p3TaYFCSnzgEKLVMXSo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    opt-einsum
    torch
  ];

  pythonImportsCheck = [ "opt_einsum_fx" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Einsum optimization using opt_einsum and PyTorch FX graph rewriting";
    homepage = "https://github.com/Linux-cpp-lisp/opt_einsum_fx";
    changelog = "https://github.com/Linux-cpp-lisp/opt_einsum_fx/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
