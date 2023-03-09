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
, dm-sonnet
, rlax
, distrax
}:

let bsuite = buildPythonPackage rec {
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

  nativeCheckInputs = [
    distrax
    dm-haiku
    dm-sonnet
    optax
    pytestCheckHook
    rlax
    tensorflow-probability
    trfl
  ];

  pythonImportsCheck = [
    "bsuite"
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

  # escape infinite recursion with rlax
  doCheck = false;

  passthru.tests = {
    check = bsuite.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    description = ''
      Core RL Behaviour Suite. A collection of reinforcement learning
      experiments
    '';
    homepage = "https://github.com/deepmind/bsuite";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}; in bsuite
