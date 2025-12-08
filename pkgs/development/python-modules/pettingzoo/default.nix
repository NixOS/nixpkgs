{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gymnasium,
  numpy,

  # optional-dependencies
  pygame,
  pymunk,
  chess,
  rlcard,
  shimmy,
  pillow,
  pybox2d,
  scipy,
  pre-commit,
  pynput,
  pytest,
  pytest-cov-stub,
  pytest-markdown-docs,
  pytest-xdist,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pettingzoo";
  version = "1.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "PettingZoo";
    tag = version;
    hash = "sha256-hQe/TMlLG//Bn8aaSo0/FPOUvOEyKfztuTIS7SMsUQ4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gymnasium
    numpy
  ];

  optional-dependencies = {
    all = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "all" ]);
    atari = [
      # multi-agent-ale-py
      pygame
    ];
    butterfly = [
      pygame
      pymunk
    ];
    classic = [
      chess
      pygame
      rlcard
      shimmy
    ];
    mpe = [ pygame ];
    other = [ pillow ];
    sisl = [
      pybox2d
      pygame
      pymunk
      scipy
    ];
    testing = [
      # autorom
      pre-commit
      pynput
      pytest
      pytest-cov-stub
      pytest-markdown-docs
      pytest-xdist
    ];
  };

  pythonImportsCheck = [ "pettingzoo" ];

  nativeCheckInputs = [
    chess
    pygame
    pymunk
    pytest-markdown-docs
    pytest-xdist
    pytestCheckHook
    rlcard
  ];

  disabledTestPaths = [
    # Require unpackaged multi_agent_ale_py
    "test/all_parameter_combs_test.py"
    "test/pickle_test.py"
    "test/unwrapped_test.py"
  ];

  disabledTests = [
    # ImportError: cannot import name 'pytest_plugins' from 'pettingzoo.classic'
    "test_chess"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Crashes on darwin: `Fatal Python error: Aborted`
    "test_multi_episode_parallel_env_wrapper"
  ];

  meta = {
    description = "API standard for multi-agent reinforcement learning environments, with popular reference environments and related utilities";
    homepage = "https://github.com/Farama-Foundation/PettingZoo";
    changelog = "https://github.com/Farama-Foundation/PettingZoo/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
