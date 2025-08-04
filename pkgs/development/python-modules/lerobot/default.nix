{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  setuptools,

  # dependencies
  av,
  datasets,
  deepdiff,
  diffusers,
  draccus,
  einops,
  flask,
  gymnasium,
  huggingface-hub,
  imageio,
  jsonlines,
  opencv-python-headless,
  packaging,
  pynput,
  pyserial,
  rerun-sdk,
  termcolor,
  torch,
  torchvision,
  wandb,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lerobot";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "lerobot";
    tag = "v${version}";
    hash = "sha256-JaspLUuSupmk6QD+mUVLuCSczTNjy0w+nsLBcy7tXnE=";
  };

  build-system = [
    cmake
    setuptools
  ];
  dontUseCmakeConfigure = true;

  pythonRelaxDeps = [
    "datasets"
    "draccus"
    "gymnasium"
    "rerun-sdk"
    "torch"
    "torchvision"
  ];

  dependencies = [
    av
    datasets
    deepdiff
    diffusers
    draccus
    einops
    flask
    gymnasium
    huggingface-hub
    imageio
    jsonlines
    opencv-python-headless
    packaging
    pynput
    pyserial
    rerun-sdk
    termcolor
    torch
    torchvision
    wandb
  ];

  pythonImportsCheck = [ "lerobot" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Making AI for Robotics more accessible with end-to-end learning";
    homepage = "https://github.com/huggingface/lerobot";
    changelog = "https://github.com/huggingface/lerobot/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
