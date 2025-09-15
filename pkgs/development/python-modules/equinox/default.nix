{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

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
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    tag = "v${version}";
    hash = "sha256-zXgAuFGWKHShKodi9swnWIry4VU9s4pBhBRoK5KzaL0=";
  };

  patches = [
    # The following two patches have been merged upstream and should be removed when updating to the next release
    # They fix the incompatibilities with jax>=0.7.0

    # https://github.com/patrick-kidger/equinox/pull/1086
    (fetchpatch2 {
      name = "remove-deprecated-batching-NotMapped";
      url = "https://github.com/patrick-kidger/equinox/commit/6a6a441ced2fe64191a087752f1c2e71a6ce39f1.patch";
      hash = "sha256-tzHFjMI3gAIh5MPkdbmzsky/oFjDEbOIkPGQMQ+gcQQ=";
    })

    # https://github.com/patrick-kidger/equinox/pull/1082
    (fetchpatch2 {
      name = "allow-creating-weak-references-to-flatten";
      url = "https://github.com/patrick-kidger/equinox/commit/62b3c94ad56bdb63524702b320e977d2d93dbe72.patch";
      hash = "sha256-c1FKCnC3/okuP2VJV4h7sPRYQeYJZSdzEG5ETL2M35k=";
    })
  ];

  # Relax speed constraints on tests that can fail on busy builders
  postPatch = ''
    substituteInPlace tests/test_while_loop.py \
      --replace-fail "speed < 0.1" "speed < 0.5" \
      --replace-fail "speed < 0.5" "speed < 1" \
      --replace-fail "speed < 1" "speed < 20"
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
