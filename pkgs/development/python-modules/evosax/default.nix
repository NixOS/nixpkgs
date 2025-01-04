{
  lib,
  buildPythonPackage,
  pythonOlder,
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

  # checks
  # brax, (unpackaged)
  # gymnax, (unpackaged)
  pytestCheckHook,
  tmpdirAsHomeHook,
  torch,
  torchvision,
}:

buildPythonPackage rec {
  pname = "evosax";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RobertTLange";
    repo = "evosax";
    tag = "v.${version}";
    hash = "sha256-v8wRiWZlJPF9pIXocQ6/caHl1W4QBNjkmuImJ6MAueo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    chex
    dotmap
    flax
    jax
    jaxlib
    matplotlib
    numpy
    pyyaml
  ];

  pythonImportsCheck = [ "evosax" ];

  nativeCheckInputs = [
    # brax
    # gymnax
    pytestCheckHook
    tmpdirAsHomeHook
    torch
    torchvision
  ];

  disabledTests = [
    # Requires unpackaged gymnax
    "test_env_ffw_rollout"

    # Tries to download a data set from the internet
    "test_vision_fitness"
  ];

  meta = {
    description = "Evolution Strategies in JAX";
    homepage = "https://github.com/RobertTLange/evosax";
    changelog = "https://github.com/RobertTLange/evosax/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
