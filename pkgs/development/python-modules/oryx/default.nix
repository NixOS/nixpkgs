{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  jax,
  jaxlib,
  tensorflow-probability,

  # tests
  inference-gym,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oryx";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "oryx";
    rev = "refs/tags/v${version}";
    hash = "sha256-1n7ogGuFNAeOyXWe0/pAouhg2+aA3MXxlCcsrfqRTdU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    jax
    jaxlib
    tensorflow-probability
  ];

  pythonImportsCheck = [ "oryx" ];

  nativeCheckInputs = [
    inference-gym
    pytestCheckHook
  ];

  meta = {
    description = "Library for probabilistic programming and deep learning built on top of Jax";
    homepage = "https://github.com/jax-ml/oryx";
    changelog = "https://github.com/jax-ml/oryx/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
