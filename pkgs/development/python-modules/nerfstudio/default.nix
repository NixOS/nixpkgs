{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  appdirs,
  av,
  awscli,
  comet-ml ? null,
  cryptography,
  fpsample,
  gdown,
  gsplat,
  h5py,
  imageio,
  importlib-metadata,
  ipywidgets,
  jaxtyping,
  jupyterlab,
  matplotlib,
  mediapy,
  msgpack,
  msgpack-numpy,
  nerfacc,
  newrawpy,
  ninja,
  nuscenes-devkit,
  open3d,
  opencv-python,
  packaging,
  pathos,
  pillow,
  plotly,
  protobuf,
  pymeshlab,
  pyngrok,
  pyquaternion,
  python-socketio,
  pytorch-msssim,
  rawpy,
  requests,
  rich,
  scikit-image,
  splines,
  tensorboard,
  timm,
  torch,
  torchmetrics,
  torchvision,
  trimesh,
  typing-extensions,
  tyro,
  viser,
  wandb,
  xatlas,
  diffusers,
  opencv-stubs,
  pre-commit,
  projectaria-tools,
  pycolmap,
  pyright,
  pytest,
  pytest-xdist,
  ruff,
  sshconf,
  transformers,
  typeguard,
  furo,
  ipython,
  myst-nb,
  nbconvert,
  nbformat,
  readthedocs-sphinx-search,
  sphinx,
  sphinx-argparse,
  sphinx-copybutton,
  sphinx-design,
  sphinxemoji,
  sphinxext-opengraph,
  accelerate,
  bitsandbytes,
  sentencepiece,
}:

buildPythonPackage rec {
  pname = "nerfstudio";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nerfstudio-project";
    repo = "nerfstudio";
    rev = "v${version}";
    hash = "sha256-/RUzs/8gDxdel0L3Gif+1d2dpcUNAAYZuSwmHfhjZrI=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    appdirs
    av
    awscli
    comet-ml
    cryptography
    fpsample
    gdown
    gsplat
    h5py
    imageio
    importlib-metadata
    ipywidgets
    jaxtyping
    jupyterlab
    matplotlib
    mediapy
    msgpack
    msgpack-numpy
    nerfacc
    newrawpy
    ninja
    nuscenes-devkit
    open3d
    opencv-python
    packaging
    pathos
    pillow
    plotly
    protobuf
    pymeshlab
    pyngrok
    pyquaternion
    python-socketio
    pytorch-msssim
    rawpy
    requests
    rich
    scikit-image
    splines
    tensorboard
    timm
    torch
    torchmetrics
    torchvision
    trimesh
    typing-extensions
    tyro
    viser
    wandb
    xatlas
  ];

  passthru.optional-dependencies = {
    dev = [
      diffusers
      opencv-stubs
      pre-commit
      projectaria-tools
      pycolmap
      pyright
      pytest
      pytest-xdist
      ruff
      sshconf
      torch
      transformers
      typeguard
    ];
    docs = [
      furo
      ipython
      myst-nb
      nbconvert
      nbformat
      readthedocs-sphinx-search
      sphinx
      sphinx-argparse
      sphinx-copybutton
      sphinx-design
      sphinxemoji
      sphinxext-opengraph
    ];
    gen = [
      accelerate
      bitsandbytes
      diffusers
      sentencepiece
      transformers
    ];
  };

  pythonImportsCheck = [ "nerfstudio" ];

  meta = {
    description = "A collaboration friendly studio for NeRFs";
    homepage = "https://github.com/nerfstudio-project/nerfstudio";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
