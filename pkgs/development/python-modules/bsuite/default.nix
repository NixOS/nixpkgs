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
  fetchpatch,
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

  patches = [
    # Convert np.int -> np.int32 since np.int is deprecated, https://github.com/google-deepmind/bsuite/pull/48
    (fetchpatch {
      url = "https://github.com/google-deepmind/bsuite/pull/48/commits/f8d81b2f1c27ef2c8c71ae286001ed879ea306ab.patch";
      hash = "sha256-FXtvVS+U8brulq8Z27+yWIimB+kigGiUOIv1SHb1TA8=";
    })
    # Replace imp with importlib, https://github.com/google-deepmind/bsuite/pull/50
    (fetchpatch {
      name = "replace-imp.patch";
      url = "https://github.com/google-deepmind/bsuite/commit/d08b63655c7efa5b5bb0f35e825e17549d23e812.patch";
      hash = "sha256-V5p/6edNXTpEckuSuxJ/mvfJng5yE/pfeMoYbvlNpEo=";
    })
  ];

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
