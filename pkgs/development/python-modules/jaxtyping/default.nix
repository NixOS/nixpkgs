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
}:

let
  self = buildPythonPackage rec {
    pname = "jaxtyping";
    version = "0.2.37";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "google";
      repo = "jaxtyping";
      tag = "v${version}";
      hash = "sha256-0a/9TSQW/k5kuucHoSUhLtRk9k+5ycbI/g6V1id3v28=";
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
      check = self.overridePythonAttrs {
        # We disable tests because they complain about the version of typeguard being too new.
        doCheck = false;
        catchConflicts = false;
      };
    };

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
