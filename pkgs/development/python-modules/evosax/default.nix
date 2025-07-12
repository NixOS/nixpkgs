{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  chex,
  dotmap,
  flax,
  jax,
  jaxlib,
  matplotlib,
  numpy,
  pyyaml,

  # tests
  # brax, (unpackaged)
  # gymnax, (unpackaged)
  pytestCheckHook,
  torch,
  torchvision,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "evosax";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RobertTLange";
    repo = "evosax";
    tag = "v.${version}";
    hash = "sha256-ye5IHM8Pn/+BXI9kcB3W281Gna9hXV8DwsaJ9Xu06fU=";
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
    # brax
    # gymnax
    pytestCheckHook
    torch
    torchvision
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Requires unpackaged gymnax
    "test_env_ffw_rollout"

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
    changelog = "https://github.com/RobertTLange/evosax/releases/tag/v.${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
