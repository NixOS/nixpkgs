{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, cython
, setuptools

# dependencies
, addict
, future
, lmdb
, numpy
, opencv4
, pillow
, pyyaml
, requests
, scikit-image
, scipy
, tensorboard
, torch
, torchvision
, tqdm
, yapf
}:

buildPythonPackage rec {
  pname = "basicsr";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XPixelGroup";
    repo = "BasicSR";
    rev = "v${version}";
    hash = "sha256-UfwwwF0h0c5oPeGhj0w5Zw2edjPNoQWNG4pKHBwMU2I=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [
    addict
    future
    lmdb
    numpy
    opencv4
    pillow
    pyyaml
    requests
    scikit-image
    scipy
    tensorboard
    torch
    torchvision
    tqdm
    yapf
  ];

  pythonImportsCheck = [
    "basicsr"
  ];

  doCheck = false; # tests require a CUDA environment

  meta = with lib; {
    changelog = "https://github.com/XPixelGroup/BasicSR/releases/tag/v${version}";
    description = "Open Source Image and Video Restoration Toolbox for Super-resolution, Denoise, Deblurring, etc. Currently, it includes EDSR, RCAN, SRResNet, SRGAN, ESRGAN, EDVR, BasicVSR, SwinIR, ECBSR, etc. Also support StyleGAN2, DFDNet";
    homepage = "https://github.com/XPixelGroup/BasicSR";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
