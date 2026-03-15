/**
  ## Known error states

  - `pkgs.python313Packages` -> "error: future-1.0.0 not supported for interpreter python3.13"
*/
{
  addict,
  buildPythonPackage,
  config,
  cython,
  fetchFromGitHub,
  future,
  lib,
  lmdb,
  numpy,
  opencv-python,
  opencv-python-withCuda,
  pillow,
  pyyaml,
  requests,
  scikit-image,
  scipy,
  setuptools,
  tensorboard,
  torch,
  torchWithCuda,
  torchvision,
  torchvisionWithCuda,
  tqdm,
  yapf,
}:

buildPythonPackage (finalAttrs: {
  version = "1.4.2";
  pname = "BasicSR";

  doCheck = false;
  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    addict
    cython
    future
    lmdb
    numpy
    pillow
    pyyaml
    requests
    scikit-image
    scipy
    tensorboard
    tqdm
    yapf
  ]
  ++ lib.lists.optionals (!config.cudaSupport) [
    opencv-python
    torch
    torchvision
  ]
  ++ lib.lists.optionals config.cudaSupport [
    opencv-python-withCuda
    torchWithCuda
    torchvisionWithCuda
  ];

  preBuild = ''
    sed -i 's/tb-nightly/tensorboard/' requirements.txt;
  '';

  src = fetchFromGitHub {
    owner = "xinntao";
    repo = "BasicSR";
    rev = "651835a1b9d38dbbdaf45750f56906be2364f01a";
    hash = "sha256-UfwwwF0h0c5oPeGhj0w5Zw2edjPNoQWNG4pKHBwMU2I=";
  };

  meta = {
    description = "Open Source Image and Video Restoration Toolbox for Super-resolution, Denoise, Deblurring, etc. Currently, it includes EDSR, RCAN, SRResNet, SRGAN, ESRGAN, EDVR, BasicVSR, SwinIR, ECBSR, etc. Also support StyleGAN2, DFDNet.";
    homepage = "https://basicsr.readthedocs.io/en/latest/";
    changelog = "https://github.com/XPixelGroup/BasicSR/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ S0AndS0 ];
  };
})
