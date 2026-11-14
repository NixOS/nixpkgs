{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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

  patches = [
    # https://github.com/jax-ml/bayeux/pull/69
    (fetchpatch {
      name = "fix-flowmc-imports";
      url = "https://github.com/jax-ml/bayeux/commit/36dbe49bb6f3e9cd22e33aabe024d02aa30ced8e.patch";
      hash = "sha256-dZCI2ebvbFA2uterRBgSHJoXlvIurUgmc1gXXeC/N0Q=";
    })
  ];

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

  pythonImportsCheck = [ "bayeux" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "State of the art inference for your bayesian models";
    homepage = "https://github.com/jax-ml/bayeux";
    changelog = "https://github.com/jax-ml/bayeux/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
