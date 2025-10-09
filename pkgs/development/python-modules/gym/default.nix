{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cloudpickle,
  numpy,
  gym-notices,
  importlib-metadata,
  pythonOlder,

  # tests
  moviepy,
  pybox2d,
  pygame,
  pytestCheckHook,
  opencv-python,
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.26.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "gym";
    tag = version;
    hash = "sha256-uJgm8l1SxIRC5PV6BIH/ht/1ucGT5UaUhkFMdusejgA=";
  };

  # Fix numpy2 compatibility
  postPatch = ''
    substituteInPlace gym/envs/classic_control/acrobot.py \
      --replace-fail "np.float_" "np.float64"

    substituteInPlace gym/utils/passive_env_checker.py \
      --replace-fail "np.bool8" "np.bool"

    substituteInPlace tests/envs/test_action_dim_check.py \
      --replace-fail "np.cast[dtype](OOB_VALUE)" "np.asarray(OOB_VALUE, dtype=dtype)" \
      --replace-fail "np.alltrue" "np.all"

    substituteInPlace tests/spaces/test_box.py \
      --replace-fail "np.bool8" "np.bool" \
      --replace-fail "np.complex_" "np.complex128"

    substituteInPlace tests/wrappers/test_record_episode_statistics.py \
      --replace-fail "np.alltrue" "np.all"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cloudpickle
    numpy
    gym-notices
  ]
  ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  pythonImportsCheck = [ "gym" ];

  nativeCheckInputs = [
    moviepy
    opencv-python
    pybox2d
    pygame
    pytestCheckHook
  ];

  preCheck = ''
    export SDL_VIDEODRIVER=dummy
  '';

  disabledTests = [
    # TypeError: Converting from sequence to b2Vec2, expected int/float arguments index 0
    "test_box_actions_out_of_bound"
    "test_env_determinism_rollout"
    "test_envs_pass_env_checker"
    "test_frame_stack"
    "test_make_autoreset_true"
    "test_passive_checker_wrapper_warnings"
    "test_pickle_env"
    "test_render_modes"

    # TypeError: in method 'b2RevoluteJoint___SetMotorSpeed', argument 2 of type 'float32'
    "test_box_actions_out_of_bound"

    # TypeError: exceptions must be derived from Warning, not <class 'NoneType'>
    "test_dict_init"

    # ValueError: setting an array element with a sequence.
    # The requested array has an inhomogeneous shape after 1 dimensions.
    # The detected shape was (2,) + inhomogeneous part
    "test_sample_contains"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Aborted
    # gym/envs/classic_control/cartpole.py", line 227 in render
    "test_autoclose"
    "test_call_async_vector_env"
    "test_call_sync_vector_env"
    "test_human_rendering"
    "test_make_render_mode"
    "test_order_enforcing"
    "test_record_simple"
    "test_record_video_reset"
    "test_record_video_step_trigger"
    "test_record_video_using_default_trigger"
    "test_record_video_within_vecto"
    "test_text_envs"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Aborted
    # gym/utils/play.py", line 62 in __init__
    "tests/utils/test_play.py"
  ];

  meta = {
    description = "Toolkit for developing and comparing your reinforcement learning agents";
    homepage = "https://www.gymlibrary.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
