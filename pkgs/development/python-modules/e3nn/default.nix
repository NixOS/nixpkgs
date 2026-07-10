{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  opt-einsum-fx,
  scipy,
  sympy,
  torch,

  # tests
  pytestCheckHook,
  llvmPackages,
}:

buildPythonPackage (finalAttrs: {
  pname = "e3nn";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "e3nn";
    repo = "e3nn";
    tag = finalAttrs.version;
    hash = "sha256-gGl0DiLU8w0jqGWA/ZzvkxdZdZCvtXqtmEEZ2dIwZ2o=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    opt-einsum-fx
    scipy
    sympy
    torch
  ];

  pythonImportsCheck = [ "e3nn" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: torch.compile does not support compiling torch.jit.script or
    # torch.jit.freeze models directly
    "test_identity"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # symbol not found in flat namespace '___kmpc_barrier'
    "test_activation"
    "test_input_weights_jit"
    "test_variance"
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # Otherwise, torch will fail to include `omp.h`:
    # torch._inductor.exc.InductorError: CppCompileError: C++ compile error OpenMP support not found
    llvmPackages.openmp
  ];

  meta = {
    description = "Modular framework for neural networks with Euclidean symmetry";
    homepage = "https://github.com/e3nn/e3nn";
    changelog = "https://github.com/e3nn/e3nn/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
