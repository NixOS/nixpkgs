{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  wheel,
  gymnasium,
  numpy,
  chess,
  pillow,
  pybox2d,
  pygame,
  pymunk,
  rlcard,
  scipy,
  pre-commit,
  pynput,
  pytest,
  pytest-cov,
  pytest-markdown-docs,
  pytest-xdist,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "pettingzoo";
  version = "1.24.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "PettingZoo";
    rev = "refs/tags/${version}";
    hash = "sha256-TVM4MrA4W6AIWEdBIecI85ahJAAc21f27OzCxSpOoZU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    gymnasium
    numpy
  ];

  passthru.optional-dependencies = {
    all = [
      chess
      # multi-agent-ale-py
      pillow
      pybox2d
      pygame
      pymunk
      rlcard
      scipy
      # shimmy
    ];
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
      # shimmy
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
      pytest-cov
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

  disabledTests =
    [
      # ImportError: cannot import name 'pytest_plugins' from 'pettingzoo.classic'
      "test_chess"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Crashes on darwin: `Fatal Python error: Aborted`
      "test_multi_episode_parallel_env_wrapper"
    ];

  meta = with lib; {
    description = "An API standard for multi-agent reinforcement learning environments, with popular reference environments and related utilities";
    homepage = "https://github.com/Farama-Foundation/PettingZoo";
    changelog = "https://github.com/Farama-Foundation/PettingZoo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
