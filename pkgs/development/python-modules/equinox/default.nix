{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  jax,
  jaxlib,
  jaxtyping,
  typing-extensions,

  # checks
  beartype,
  optax,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "equinox";
  version = "0.11.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    tag = "v${version}";
    hash = "sha256-xCAk9qac2ZmevUMMRgBokLKuGWyrF4fGpN03li49cR8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jax
    jaxlib
    jaxtyping
    typing-extensions
  ];

  nativeCheckInputs = [
    beartype
    optax
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # SystemError: nanobind::detail::nb_func_error_except(): exception could not be translated!
    "test_filter"
  ];

  pythonImportsCheck = [ "equinox" ];

  meta = {
    description = "JAX library based around a simple idea: represent parameterised functions (such as neural networks) as PyTrees";
    changelog = "https://github.com/patrick-kidger/equinox/releases/tag/v${version}";
    homepage = "https://github.com/patrick-kidger/equinox";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
