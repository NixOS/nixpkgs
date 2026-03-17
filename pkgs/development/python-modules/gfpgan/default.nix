{
  basicsr ? python312Packages.basicsr,
  buildPythonPackage,
  config,
  cython ? python312Packages.cython,
  facexlib ? python312Packages.facexlib,
  fetchFromGitHub,
  lib,
  lmdb,
  numpy ? python312Packages.numpy,
  opencv-python ? python312Packages.opencv-python,
  opencv-python-withCuda ? python312Packages.opencv-python-withCuda,
  python312Packages,
  pyyaml ? python312Packages.pyyaml,
  scipy ? python312Packages.scipy,
  setuptools ? python312Packages.setuptools,
  tensorboard ? python312Packages.tensorboard,
  torch ? python312Packages.torch,
  torchWithCuda ? python312Packages.torchWithCuda,
  torchvision ? python312Packages.torchvision,
  torchvisionWithCuda ? python312Packages.torchvisionWithCuda,
  tqdm ? python312Packages.tqdm,
  yapf,
}:

buildPythonPackage (finalAttrs: {
  version = "1.3.8";
  pname = "GFPGAN";

  dependencies = [
    basicsr
    cython
    facexlib
    lmdb
    numpy
    pyyaml
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

  doCheck = false;
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "TencentARC";
    repo = "GFPGAN";
    rev = "2eac2033893ca7f427f4035d80fe95b92649ac56";
    hash = "sha256-frJ3hSniHvCSEPB1awJsXLuUxYRRMbV9GS4GSPKwXOg=";
  };

  meta = {
    description = "GFPGAN aims at developing Practical Algorithms for Real-world Face Restoration.";
    homepage = "https://github.com/TencentARC/GFPGAN";
    changelog = "https://github.com/TencentARC/GFPGAN/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      S0AndS0
    ];
  };
})
