/**
  ## Known error states

  - `pkgs.python313Packages` -> "error: future-1.0.0 not supported for interpreter python3.13"
*/
{
  addict ? python312Packages.addict,
  buildPythonPackage,
  config,
  cython ? python312Packages.cython,
  fetchFromGitHub,
  future ? python312Packages.future,
  lib,
  lmdb,
  numpy ? python312Packages.numpy,
  opencv-python ? python312Packages.opencv-python,
  opencv-python-withCuda ? python312Packages.opencv-python-withCuda,
  pillow ? python312Packages.pillow,
  python312Packages,
  pyyaml ? python312Packages.pyyaml,
  requests ? python312Packages.requests,
  scikit-image ? python312Packages.scikit-image,
  scipy ? python312Packages.scipy,
  setuptools ? python312Packages.setuptools,
  tensorboard,
  torch ? python312Packages.torch,
  torchWithCuda ? python312Packages.torchWithCuda,
  torchvision ? python312Packages.torchvision,
  torchvisionWithCuda ? python312Packages.torchvisionWithCuda,
  tqdm ? python312Packages.tqdm,
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
