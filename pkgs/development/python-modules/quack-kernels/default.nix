{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  apache-tvm-ffi,
  einops,
  nvidia-cutlass-dsl,
  torch,
  torch-c-dlpack-ext,

  # optional-dependencies
  # nvidia-matmul-heuristics,
  jax,
  # jax-tvm-ffi,
  pandas,
}:
buildPythonPackage (finalAttrs: {
  pname = "quack-kernels";
  version = "0.5.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "quack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L6kReIaCTVxJPYkkYn5aCXCChAsaxn/ikcBHTHzDmgs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    apache-tvm-ffi
    einops
    nvidia-cutlass-dsl
    torch
    torch-c-dlpack-ext
  ];

  optional-dependencies = {
    heuristics = [
      # nvidia-matmul-heuristics
    ];
    jax = [
      jax
      # jax-tvm-ffi
    ];
    bench = [
      pandas
    ];
  };

  pythonImportsCheck = [ "quack" ];

  # Fatal Python error: Aborted
  doCheck = false;

  meta = {
    description = "Quirky Assortment of CuTe Kernels";
    homepage = "https://github.com/Dao-AILab/quack";
    changelog = "https://github.com/Dao-AILab/quack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      prince213
    ];
  };
})
