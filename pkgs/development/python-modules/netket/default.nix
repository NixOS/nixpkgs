{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  hatchling,
  hatch-vcs,
  jax,
  jaxlib,
  numpy,
  scipy,
  tqdm,
  numba,
  igraph,
  flax,
  orjson,
  optax,
  beartype,
  rich,
  equinox,
  plum-dispatch,
  sparse,
  einops,
  pytestCheckHook,
  pytest-xdist,
  pytest-cov-stub,
  pytest-json-report,
  qutip,
  networkx,
  matplotlib,
  pyscf,
  tensorboardx,
  h5py,
}:

buildPythonPackage (finalAttrs: {
  pname = "netket";
  version = "3.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netket";
    repo = "netket";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jpF3OoVDkGvns2XU3kyfCSjh/Nkqj6R5GKAGqWchrTg=";
  };

  build-system = [
    setuptools-scm
    hatchling
    hatch-vcs
  ];

  dependencies = [
    jax
    jaxlib
    numpy
    scipy
    tqdm
    numba
    igraph
    flax
    orjson
    optax
    beartype
    rich
    equinox
    plum-dispatch
    sparse
    einops
  ];

  optional-dependencies = {
    pyscf = [ pyscf ];
    extra = [
      tensorboardx
      #openfermion # not packaged yet
      h5py
      qutip
    ];
  };

  doCheck = false; # tests use up my ram, and they fail anyway

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-cov-stub
    pytest-json-report
    networkx
    matplotlib
  ];

  # https://github.com/netket/netket/blob/v3.21.0/.github/workflows/CI.yml#L81-L83
  env.NETKET_EXPERIMENTAL = "1";
  pytestFlags = [
    "--jax-cpu-disable-async-dispatch"
    "--clear-cache-every"
    "200"
  ];

  pythonImportsCheck = [ "netket" ];

  meta = {
    homepage = "https://www.netket.org";
    changelog = "https://github.com/netket/netket/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Machine-learning toolbox for quantum physics";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
})
