{ lib
, fetchPypi
, buildPythonPackage
, frozendict
, termcolor
, matplotlib
, gym
, pandas
, scipy
, absl-py
, dm-env
, plotnine
, scikitimage
, dm-tree
, patsy
, tensorflow-probability
, dm-haiku
, statsmodels
, mizani
, trfl
, optax
, pytestCheckHook
, dm-sonnet }:

buildPythonPackage rec {
  pname = "bsuite";
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ak9McvXl7Nz5toUaPaRaJek9lurxiQiIW209GnZEjX0=";
  };

  buildInputs = [
    absl-py
    dm-env
    dm-tree
    frozendict
    gym
    matplotlib
    mizani
    pandas
    patsy
    plotnine
    scikitimage
    scipy
    statsmodels
    termcolor
  ];

  checkInputs = [
    dm-haiku
    dm-sonnet
    optax
    pytestCheckHook
    tensorflow-probability
    trfl
  ];

  pythonImportsCheck = [
    "bsuite"
  ];

  disabledTestPaths = [
    # Disabled because tests require module rlax but this results in infinite
    # recursion error
    "bsuite/baselines/jax/actor_critic/run_test.py"
    "bsuite/baselines/jax/actor_critic_rnn/run_test.py"
    "bsuite/baselines/jax/boot_dqn/run_test.py"
    "bsuite/baselines/jax/dqn/run_test.py"
  ];

  disabledTests = [
    # Tests require network connection
    "test_run9"
    "test_longer_action_sequence"
    "test_reset"
    "test_step_after_reset"
    "test_step_on_fresh_environment"
    "test_longer_action_sequence"
    "test_reset"
    "test_step_after_reset"
    "test_step_on_fresh_environment"
    "test_longer_action_sequence"
    "test_reset"
    "test_step_after_reset"
    "test_step_on_fresh_environment"
    "test_logger"
    "test_episode_truncation"
  ];

  meta = with lib; {
    description = ''
      Core RL Behaviour Suite. A collection of reinforcement learning
      experiments
    '';
    homepage = "https://github.com/deepmind/bsuite";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
