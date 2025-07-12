{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  numpy,
  pip,
  termcolor,
  pytestCheckHook,
  torch,
  fetchpatch2,
}:

buildPythonPackage rec {
  pname = "rlcard";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datamllab";
    repo = "rlcard";
    tag = version;
    hash = "sha256-SWj6DBItQzSM+nioV54a350Li7tbBaVXsQxNAqVgB0k=";
  };

  patches = [
    # Remove distutils to make it compatible with Python 3.12
    # https://github.com/datamllab/rlcard/pull/323
    (fetchpatch2 {
      name = "remove-distutils.patch";
      url = "https://github.com/datamllab/rlcard/commit/e44378157aaf229ffe2aaef9fafe500c2844045e.patch";
      hash = "sha256-aQS4d9ETj6pDv26G77mC+0xHQMA2hjspAxtAyz0rA6Y=";
    })
  ];

  # AttributeError: 'numpy.ndarray' object has no attribute 'tostring'
  # tobytes() has the exact same behavior as tostring()
  # https://github.com/datamllab/rlcard/pull/328
  postPatch = ''
    substituteInPlace rlcard/agents/cfr_agent.py \
      --replace-fail \
        "state['obs'].tostring()" \
        "state['obs'].tobytes()"
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    numpy
    # pip is required at runtime (https://github.com/datamllab/rlcard/blob/1.0.7/rlcard/utils/utils.py#L10)
    pip
    termcolor
  ];

  pythonImportsCheck = [ "rlcard" ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  disabledTests = [
    # AttributeError: module 'numpy' has no attribute 'int'.
    # https://github.com/datamllab/rlcard/issues/266
    "test_decode_action"
    "test_get_legal_actions"
    "test_get_perfect_information"
    "test_get_player_id"
    "test_init_game"
    "test_is_deterministic"
    "test_proceed_game"
    "test_reset_and_extract_state"
    "test_run"
    "test_step"
    "test_step"
    "test_step_back"
    "test_step_back"

    # ValueError: setting an array element with a sequence. The requested array has an inhomogeneous shape after 3 dimensions. The detected shape was (1, 1, 5) + inhomogeneous part.
    "test_reorganize"
  ];

  meta = with lib; {
    description = "Reinforcement Learning / AI Bots in Card (Poker) Games - Blackjack, Leduc, Texas, DouDizhu, Mahjong, UNO";
    homepage = "https://github.com/datamllab/rlcard";
    changelog = "https://github.com/datamllab/rlcard/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
