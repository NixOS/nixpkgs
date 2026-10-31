{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gitpython,
  numpy,
  onnx,
  onnxscript,
  tensorboard,
  tensordict,
  torch,
  torchvision,

  # optional-dependencies
  wandb,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rsl-rl-lib";
  version = "5.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leggedrobotics";
    repo = "rsl_rl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vSKy5Yg4Wk3kildaBoNnin9aVAZnp72U/jWoWd5QIYU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gitpython
    numpy
    onnx
    onnxscript
    tensorboard
    tensordict
    torch
    torchvision
  ];

  optional-dependencies = {
    # https://github.com/neptune-ai/neptune-client is archived
    # neptune = [
    #   neptune
    # ];
    wandb = [
      wandb
    ];
  };

  pythonImportsCheck = [ "rsl_rl" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Fast and simple implementation of learning algorithms for robotics";
    homepage = "https://github.com/leggedrobotics/rsl_rl";
    changelog = "https://github.com/leggedrobotics/rsl_rl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
