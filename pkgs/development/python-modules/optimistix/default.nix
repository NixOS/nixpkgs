{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  equinox,
  jax,
  jaxtyping,
  lineax,
  typing-extensions,

  # checks
  beartype,
  jaxlib,
  optax,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "optimistix";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "optimistix";
    rev = "refs/tags/v${version}";
    hash = "sha256-0ehNApiBoiAb8LFBW81ZCRPsjTVQG8zRTVSAp7oHF8w=";
  };

  build-system = [ hatchling ];

  dependencies = [
    equinox
    jax
    jaxtyping
    lineax
    typing-extensions
  ];

  pythonImportsCheck = [ "optimistix" ];

  nativeCheckInputs = [
    beartype
    jaxlib
    optax
    pytestCheckHook
    pytest-xdist
  ];

  meta = {
    description = "Nonlinear optimisation (root-finding, least squares, ...) in JAX+Equinox";
    homepage = "https://github.com/patrick-kidger/optimistix";
    changelog = "https://github.com/patrick-kidger/optimistix/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
