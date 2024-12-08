{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  corner,
  equinox,
  evosax,
  jax,
  jaxlib,
  optax,
  tqdm,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flowmc";
  version = "0.3.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "kazewong";
    repo = "flowMC";
    rev = "refs/tags/flowMC-${version}";
    hash = "sha256-unvbNs0AOzW4OI+9y6KxoBC5yEjEz+q0PZblQLXCC/Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    corner
    equinox
    evosax
    jax
    jaxlib
    optax
    tqdm
  ];

  pythonImportsCheck = [ "flowMC" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Normalizing-flow enhanced sampling package for probabilistic inference in Jax";
    homepage = "https://github.com/kazewong/flowMC";
    changelog = "https://github.com/kazewong/flowMC/releases/tag/flowMC-${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
