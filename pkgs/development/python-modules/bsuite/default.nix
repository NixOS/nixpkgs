{
  lib,
  absl-py,
  buildPythonPackage,
  distrax,
  dm-env,
  dm-haiku,
  dm-sonnet,
  dm-tree,
  fetchpatch,
  fetchPypi,
  frozendict,
  gym,
  matplotlib,
  mizani,
  optax,
  pandas,
  patsy,
  plotnine,
  pytestCheckHook,
  pythonOlder,
  rlax,
  scikit-image,
  scipy,
  setuptools,
  statsmodels,
  tensorflow-probability,
  termcolor,
}:

let
  bsuite = buildPythonPackage rec {
    pname = "bsuite";
    version = "0.3.5";
    pyproject = true;

    disabled = pythonOlder "3.7";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-ak9McvXl7Nz5toUaPaRaJek9lurxiQiIW209GnZEjX0=";
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
      check = bsuite.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    meta = with lib; {
      description = "Collection of experiments that investigate core capabilities of a reinforcement learning (RL) agent";
      homepage = "https://github.com/deepmind/bsuite";
      changelog = "https://github.com/google-deepmind/bsuite/releases/tag/${version}";
      license = licenses.asl20;
      maintainers = with maintainers; [ onny ];
    };
  };
in
bsuite
