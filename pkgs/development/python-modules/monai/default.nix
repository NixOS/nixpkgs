{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  ninja,
  numpy,
  packaging,
  pybind11,
  torch,
  which,

  # optional dependencies (incomplete; for monai-label):
  fire,
  gdown,
  ignite,
  itk,
  lmdb,
  nibabel,
  numpymaxflow,
  mlflow,
  openslide,
  pillow,
  psutil,
  scikit-image,
  tensorboard,
  torchvision,
  tqdm,
}:

buildPythonPackage rec {
  pname = "monai";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "MONAI";
    tag = version;
    hash = "sha256-PovYyRLgoYwxqGeCBpWxX/kdClYtYK1bgy8yRa9eue8=";
    # note: upstream consistently seems to modify the tag shortly after release,
    # so best to wait a few days before updating
  };

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES;
  '';

  build-system = [
    ninja
    which
  ];

  buildInputs = [ pybind11 ];

  dependencies = [
    numpy
    packaging
    torch
  ];

  optional-dependencies = {
    fire = [ fire ];
    gdown = [ gdown ];
    ignite = [ ignite ];
    itk = [ itk ];
    lmdb = [ lmdb ];
    mlflow = [ mlflow ];
    nibabel = [ nibabel ];
    numpymaxflow = [ numpymaxflow ];
    openslide = [ openslide ];
    pillow = [ pillow ];
    psutil = [ psutil ];
    scikit-image = [ scikit-image ];
    tensorboard = [ tensorboard ];
    torchvision = [ torchvision ];
    tqdm = [ tqdm ];
  };

  env.BUILD_MONAI = 1;

  doCheck = false; # takes too long; tries to download data

  pythonImportsCheck = [
    "monai"
    "monai.apps"
    "monai.data"
    "monai.engines"
    "monai.handlers"
    "monai.inferers"
    "monai.losses"
    "monai.metrics"
    "monai.optimizers"
    "monai.networks"
    "monai.transforms"
    "monai.utils"
    "monai.visualize"
  ];

  meta = with lib; {
    description = "Pytorch framework (based on Ignite) for deep learning in medical imaging";
    homepage = "https://github.com/Project-MONAI/MONAI";
    changelog = "https://github.com/Project-MONAI/MONAI/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
