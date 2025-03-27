{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  jax,
  jaxtyping,
  typing-extensions,
  wadler-lindig,

  # tests
  beartype,
  optax,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "equinox";
  version = "0.11.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    tag = "v${version}";
    hash = "sha256-hor2qw+aTL7yhV53E/y5DUwyDEYJA8RPRS39xxa8xcw=";
  };

  # Relax speed constraints on tests that can fail on busy builders
  postPatch = ''
    substituteInPlace tests/test_while_loop.py \
      --replace-fail "speed < 0.1" "speed < 0.5" \
      --replace-fail "speed < 0.5" "speed < 1" \
      --replace-fail "speed < 1" "speed < 4" \
  '';

  build-system = [ hatchling ];

  dependencies = [
    jax
    jaxtyping
    typing-extensions
    wadler-lindig
  ];

  nativeCheckInputs = [
    beartype
    optax
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Since jax 0.5.3:
    # DeprecationWarning: shape requires ndarray or scalar arguments, got <class 'jax._src.api.ShapeDtypeStruct'> at position 0. In a future JAX release this will be an error.
    # https://github.com/patrick-kidger/equinox/issues/979
    "-W"
    "ignore::DeprecationWarning"
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
