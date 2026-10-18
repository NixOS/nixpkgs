{
  lib,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  dm-env,
  dm-tree,
  frozendict,
  gym,
  matplotlib,
  mizani,
  pandas,
  patsy,
  plotnine,
  scikit-image,
  scipy,
  statsmodels,
  termcolor,

  # tests
  distrax,
  dm-haiku,
  dm-sonnet,
  fetchPypi,
  optax,
  pytestCheckHook,
  rlax,
  tensorflow-probability,
}:

buildPythonPackage (finalAttrs: {
  pname = "bsuite";
  version = "0.3.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GPHmxJ/0CSKItlfk+YPHeUaTMA+4U81l1Z4Cfe+hikA=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
  ];

  pythonImportsCheck = [ "bsuite" ];

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

  # Escape infinite recursion with rlax
  doCheck = false;

  passthru.tests = {
    check = finalAttrs.finalPackage.overrideAttrs {
      doInstallCheck = true;
    };
  };

  meta = {
    description = "Collection of experiments that investigate core capabilities of a reinforcement learning (RL) agent";
    homepage = "https://github.com/deepmind/bsuite";
    changelog = "https://github.com/google-deepmind/bsuite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
})
