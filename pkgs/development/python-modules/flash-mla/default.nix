{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  cudaPackages,

  # build-system
  setuptools,
  torch,

  # buildInputs
  pybind11,

  # passthru
  nix-update-script,

  config,
  cudaSupport ? config.cudaSupport,
}:

let
  inherit (lib)
    getBin
    optionalAttrs
    optionals
    ;
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "flash-mla";
  version = "0-unstable-2026-04-29";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "FlashMLA";
    rev = "9241ae3ef9bac614dd25e45e507e089f888280e0";
    # Using the cutlass git subodules is necessary to get cutlass/util/command_line.h which is not
    # shipped in cudaPackages.cutlass
    fetchSubmodules = true;
    hash = "sha256-rHHoDGEbBIvLRT0ZYOWQHrqyPBWtCpmF/AIcqFieomE=";
  };

  patches = [
    (replaceVars ./inject-git-rev.patch {
      git_rev = "+${finalAttrs.src.rev}";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        'subprocess.run(["git", "submodule", "update", "--init", "csrc/cutlass"])' \
        ""
  '';

  env = optionalAttrs cudaSupport {
    CUDA_HOME = (getBin cudaPackages.cuda_nvcc).outPath;
  };

  build-system = [
    setuptools
    torch
  ];

  buildInputs = [
    pybind11
  ]
  ++ optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart # cuda_runtime.h
      libcublas # cublas_v2.h
      libcurand # curand_kernel.h
      libcusolver # cusolverDn.h
      libcusparse # cusparse.h
    ]
  );

  pythonImportsCheck = [ "flash_mla" ];

  # Tests are not meant to run with pytest
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Efficient Multi-head Latent Attention Kernels";
    homepage = "https://github.com/deepseek-ai/FlashMLA";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !cudaSupport;
  };
})
