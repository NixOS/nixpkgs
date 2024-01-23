{ lib
, fetchPypi
, buildPythonPackage
, fetchpatch
, frozendict
, termcolor
, matplotlib
, gym
, pandas
, scipy
, absl-py
, dm-env
, plotnine
, scikit-image
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
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ak9McvXl7Nz5toUaPaRaJek9lurxiQiIW209GnZEjX0=";
  };

  patches = [
    (fetchpatch {  # Convert np.int -> np.int32 since np.int is deprecated (https://github.com/google-deepmind/bsuite/pull/48)
      url = "https://github.com/google-deepmind/bsuite/pull/48/commits/f8d81b2f1c27ef2c8c71ae286001ed879ea306ab.patch";
      hash = "sha256-FXtvVS+U8brulq8Z27+yWIimB+kigGiUOIv1SHb1TA8=";
    })
  ];

  propagatedBuildInputs = [
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
    scikit-image
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
