{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  tensorflow,
  torch,

  # passthru
  jaxtyping,
}:

buildPythonPackage (finalAttrs: {
  pname = "jaxtyping";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "jaxtyping";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Vt6UD1xQkwve6yDVi5XQCoJ/IsJWHCkGesj66myQq4=";
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
    tensorflow
    torch
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
