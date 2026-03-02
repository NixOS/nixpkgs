{
  buildPythonPackage,
  config,
  cython,
  fetchFromGitHub,
  filterpy,
  lib,
  numba,
  numpy,
  opencv-python,
  opencv-python-withCuda,
  pillow,
  scipy,
  setuptools,
  torch,
  torchWithCuda,
  torchvision,
  torchvisionWithCuda,
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
