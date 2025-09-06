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
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "lerobot";
    tag = "v${version}";
    hash = "sha256-gDT4lA+yb3X6jKkw0kRkYpWVnWnX9SL9rdEQglmBDAc=";
  };

  build-system = [
    cmake
    setuptools
  ];
  dontUseCmakeConfigure = true;

  pythonRelaxDeps = [
    "rerun-sdk"
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
