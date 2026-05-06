{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  torch,

  nanobind,

  unittestCheckHook,
}:

let
  inherit (torch) cudaCapabilities cudaPackages; # cudaSupport
  cudaSupport = false;
in
buildPythonPackage rec {
  pname = "comfy-kitchen";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-kitchen";
    tag = "v${version}";
    hash = "sha256-v0xNWBn/FiRsPYe1ayVI8jRouhrEcITxMTJYJ773+/s=";
  };
  build-system = [
    setuptools
  ];

  # TODO: make cuda stuff work
  pypaBuildFlags = [
    "--config-setting=--build-option=--no-cuda"
  ];

  preBuild = ''
    substituteInPlace ./setup.py \
      --replace-fail "BUILD_NO_CUDA = False" "BUILD_NO_CUDA = True"
  '';

  buildInputs = [] ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      # # flash-attn build
      # cuda_cudart # cuda_runtime_api.h
      # libcusparse # cusparse.h
      # cuda_cccl # nv/target
      libcublas # cublas_v2.h
      # libcusolver # cusolverDn.h
      # libcurand # curand_kernel.h
    ]
  );

  dependencies = [
    nanobind
    torch
  ];

  # optional-dependencies = {
  #   cublas = [
  #   ];
  # };

  pythonImportsCheck = [ "comfy_kitchen" ];

  meta = {
    description = "Fast kernel library for Diffusion inference with multiple compute backends";
    homepage = "https://github.com/Comfy-Org/comfy-kitchen/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
