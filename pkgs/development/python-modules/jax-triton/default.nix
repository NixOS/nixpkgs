{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  absl-py,
  jax,
  triton,
  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage rec {
  pname = "jax-triton";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "jax-triton";
    tag = "v${version}";
    hash = "sha256-1zqCYA/iGKt2GQvGywwT+56GnGgvxh8RR99RRpDjvYg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    absl-py
    jax
    triton
  ];

  # require CUDA supported jax
  dontUsePythonImportsCheck = !cudaSupport;

  pythonImportsCheck = [ "jax_triton" ];

  # require GPU access
  doCheck = false;

  meta = {
    description = "Jax-triton contains integrations between JAX and OpenAI Triton";
    homepage = "https://github.com/jax-ml/jax-triton";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
