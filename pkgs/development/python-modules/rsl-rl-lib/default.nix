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
  version = "5.4.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leggedrobotics";
    repo = "rsl_rl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m9M9yWCKs5vLHb7k5A7AFfHko980HDeF3qr1x7s1KGE=";
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

  meta = {
    description = "Fast and simple implementation of learning algorithms for robotics";
    homepage = "https://github.com/leggedrobotics/rsl_rl";
    changelog = "https://github.com/leggedrobotics/rsl_rl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
