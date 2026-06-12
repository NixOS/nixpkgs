{
  buildPythonPackage,
  config,
  cython ? python312Packages.cython,
  fetchFromGitHub,
  filterpy ? python312Packages.filterpy,
  lib,
  numba ? python312Packages.numba,
  numpy ? python312Packages.numpy,
  opencv-python ? python312Packages.opencv-python,
  opencv-python-withCuda ? python312Packages.opencv-python-withCuda,
  pillow ? python312Packages.pillow,
  python312Packages,
  scipy ? python312Packages.filterpy,
  setuptools ? python312Packages.setuptools,
  torch ? python312Packages.torch,
  torchWithCuda ? python312Packages.torchWithCuda,
  torchvision ? python312Packages.torchvision,
  torchvisionWithCuda ? python312Packages.torchvisionWithCuda,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  version = "0.2.5";
  pname = "facexlib";

  dependencies = [
    cython
    filterpy
    numba
    numpy
    pillow
    scipy
    tqdm
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

  doCheck = false;
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "xinntao";
    repo = "facexlib";
    rev = "9557a45094f3e4619fc5c145ef76adf9710fd054";
    hash = "sha256-2mqjGtrOigOxyGFEFZBK2/SqEhIv5cbrQU/bYDVje7Q=";
  };

  meta = {
    description = "FaceXlib aims at providing ready-to-use face-related functions based on current STOA open-source methods.";
    homepage = "https://github.com/xinntao/facexlib";
    changelog = "https://github.com/xinntao/facexlib/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      S0AndS0
    ];
  };
})
