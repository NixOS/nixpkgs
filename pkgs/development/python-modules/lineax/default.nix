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
  typing-extensions,

  # tests
  beartype,
  pytest,
  python,
}:

buildPythonPackage rec {
  pname = "lineax";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "lineax";
    rev = "refs/tags/v${version}";
    hash = "sha256-rM3H+q75F98eEIJkEszWgxD5C5vGK5RlYtVv8GD/VC0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    equinox
    jax
    jaxtyping
    typing-extensions
  ];

  pythonImportsCheck = [ "lineax" ];

  nativeCheckInputs = [
    beartype
    pytest
  ];

  # Intentionaly not using pytest directly as it leads to JAX out-of-memory'ing
  # https://github.com/patrick-kidger/lineax/blob/1909d190c1963d5f2d991508c1b2714f2266048b/tests/README.md
  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m tests

    runHook postCheck
  '';

  meta = {
    description = "Linear solvers in JAX and Equinox";
    homepage = "https://github.com/patrick-kidger/lineax";
    changelog = "https://github.com/patrick-kidger/lineax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
