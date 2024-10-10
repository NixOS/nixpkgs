{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  arviz,
  blackjax,
  flowmc,
  jax,
  jaxopt,
  numpyro,
  nutpie,
  optax,
  optimistix,
  oryx,
  pymc,
  tensorflow-probability,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bayeux-ml";
  version = "0.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "bayeux";
    rev = "refs/tags/v${version}";
    hash = "sha256-dnfs5AiKdoYeLmgWqbvrWrbp77kXiXUEIhUsrDYQXYE=";
  };

  build-system = [ flit-core ];

  dependencies = [
    arviz
    blackjax
    flowmc
    jax
    jaxopt
    numpyro
    nutpie
    optax
    optimistix
    oryx
    pymc
    tensorflow-probability
  ];

  pythonImportsCheck = [ "bayeux_ml" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "State of the art inference for your bayesian models";
    homepage = "https://github.com/jax-ml/bayeux";
    changelog = "https://github.com/jax-ml/bayeux/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
