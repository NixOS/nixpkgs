{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  wadler-lindig,

  # tests
  cloudpickle,
  equinox,
  ipython,
  jax,
  jaxlib,
  pytestCheckHook,
  torch,
  # python <= 3.12 only
  tensorflow,

  # passthru
  jaxtyping,
}:

buildPythonPackage (finalAttrs: {
  pname = "jaxtyping";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "jaxtyping";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ex84xtns3wtIodXdpC6/88Kn0I+33B7ScHPIc9C5tuY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    wadler-lindig
  ];

  pythonImportsCheck = [ "jaxtyping" ];

  nativeCheckInputs = [
    cloudpickle
    equinox
    ipython
    jax
    jaxlib
    pytestCheckHook
    torch
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    tensorflow
  ];

  doCheck = false;

  # Enable tests via passthru to avoid cyclic dependency with equinox.
  passthru.tests = {
    check = jaxtyping.overridePythonAttrs {
      # We disable tests because they complain about the version of typeguard being too new.
      doCheck = false;
      catchConflicts = false;
    };
  };

  meta = {
    description = "Type annotations and runtime checking for JAX arrays and PyTrees";
    homepage = "https://github.com/patrick-kidger/jaxtyping";
    changelog = "https://github.com/patrick-kidger/jaxtyping/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
