{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  pythonRelaxDepsHook,
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
    version = "0.2.31";
    pyproject = true;

    disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "google";
      repo = "jaxtyping";
      rev = "refs/tags/v${version}";
      hash = "sha256-kuGFzp8sDLq6J/qq8ap3lD3n1pABHurXcbRUtDQyWwE=";
    };

    build-system = [
      hatchling
      pythonRelaxDepsHook
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
