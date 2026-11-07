{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dotmap,
  flax,
  jax,
  matplotlib,
  numpy,

  # tests
  brax,
  pytestCheckHook,
  torch,
  torchvision,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "evosax";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RobertTLange";
    repo = "evosax";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-j+pYgbd/60zbom3QlQi4U1VpEI5pn+QqThQfGhHGqQ8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dotmap
    flax
    jax
    matplotlib
    numpy
  ];

  pythonImportsCheck = [ "evosax" ];

  nativeCheckInputs = [
    brax
    # gymnax (unpackaged)
    pytestCheckHook
    torch
    torchvision
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Requires unpackaged gymnax
    "test_env_ffw_rollout"

    # TypeError: ShapedArray.__init__() got an unexpected keyword argument 'named_shape'
    "test_base_api"
    "test_run"
    "test_run_scan"

    # Tries to download a data set from the internet
    "test_brax_problem_eval"
    "test_brax_problem_init"
    "test_brax_problem_sample"
    "test_gymnax_problem_eval"
    "test_gymnax_problem_init"
    "test_gymnax_problem_sample"
    "test_torchvision_problem_eval"
    "test_torchvision_problem_init"
    "test_torchvision_problem_sample"
    "test_vision_fitness"
  ];

  meta = {
    description = "Evolution Strategies in JAX";
    homepage = "https://github.com/RobertTLange/evosax";
    changelog = "https://github.com/RobertTLange/evosax/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
