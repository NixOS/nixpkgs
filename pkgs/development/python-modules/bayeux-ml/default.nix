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
  version = "0.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "bayeux";
    tag = "v${version}";
    hash = "sha256-f+Ul7lE+rt6U0iwvV7NTe8wcDfFtZy8fIgmuNeM1e2M=";
  };

  build-system = [ flit-core ];

  pythonRemoveDeps = [
    "nutpie"
  ];

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

  pythonImportsCheck = [ "bayeux" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "State of the art inference for your bayesian models";
    homepage = "https://github.com/jax-ml/bayeux";
    changelog = "https://github.com/jax-ml/bayeux/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
