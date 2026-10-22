{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  gymnasium,
  numpy,
  typing-extensions,

  # optional-dependencies
  # atari:
  pygame-ce,
  # butterfly:
  pymunk,
  # classic:
  chess,
  rlcard,
  shimmy,
  # other:
  moviepy,
  pillow,
  # sisl
  scipy,
  pybox2d,
  swig,

  # tests
  pytest-markdown-docs,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pettingzoo";
  version = "1.27.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "PettingZoo";
    tag = finalAttrs.version;
    hash = "sha256-fiaHuMmoaL6VweDcXZVLaQcvXHG3B0zcOrePlOajQzo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gymnasium
    numpy
    typing-extensions
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
      # open-spiel (unpackaged)
    ];
    mpe = [ pygame-ce ];
    other = [
      moviepy
      pillow
    ];
    sisl = [
      pygame-ce
      pymunk
      scipy
      pybox2d
    ]
    ++ lib.optionals (pythonAtLeast "3.14") [
      swig
    ];
  };

  pythonImportsCheck = [ "pettingzoo" ];

  nativeCheckInputs = [
    chess
    moviepy
    pybox2d
    pygame-ce
    pymunk
    pytest-markdown-docs
    pytest-xdist
    pytestCheckHook
    rlcard
    scipy
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

    # pygame.error: No available video device
    "test_kaz_obs_updates"
    "test_rgb_array_render_does_not_init_audio"
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
