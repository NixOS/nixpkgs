{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  typeguard,
  cloudpickle,
  equinox,
  ipython,
  jax,
  jaxlib,
  pytestCheckHook,
  tensorflow,
  torch,
}:

let
  self = buildPythonPackage rec {
    pname = "jaxtyping";
    version = "0.2.33";
    pyproject = true;

    disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "google";
      repo = "jaxtyping";
      rev = "refs/tags/v${version}";
      hash = "sha256-CL1EONbjjT3SCAn2o1x+1cgfuYWMEgQwbX9j34t+HGs=";
    };

    build-system = [
      hatchling
    ];

    dependencies = [
      typeguard
    ];

    pythonRelaxDeps = [ "typeguard" ];

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
      check = self.overridePythonAttrs {
        # We disable tests because they complain about the version of typeguard being too new.
        doCheck = false;
        catchConflicts = false;
      };
    };

    pythonImportsCheck = [ "jaxtyping" ];

    meta = {
      description = "Type annotations and runtime checking for JAX arrays and PyTrees";
      homepage = "https://github.com/google/jaxtyping";
      changelog = "https://github.com/patrick-kidger/jaxtyping/releases/tag/v${version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ GaetanLepage ];
    };
  };
in
self
