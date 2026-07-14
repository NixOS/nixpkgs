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
  pygame-ce,
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

buildPythonPackage (finalAttrs: {
  pname = "pettingzoo";
  version = "1.26.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "PettingZoo";
    tag = finalAttrs.version;
    hash = "sha256-WrfjkDnmir6bZvtMD7MVQKVoGvK+lutlOoNe9SNQ8jU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gymnasium
    numpy
  ];

  optional-dependencies = {
    atari = [
      # multi-agent-ale-py
      pygame-ce
    ];
    butterfly = [
      pygame-ce
      pymunk
    ];
    classic = [
      chess
      pygame-ce
      rlcard
      shimmy
    ];
    mpe = [ pygame-ce ];
    other = [ pillow ];
    sisl = [
      pybox2d
      pygame-ce
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
    pygame-ce
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
    changelog = "https://github.com/Farama-Foundation/PettingZoo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
