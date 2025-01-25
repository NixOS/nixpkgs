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

  fetchpatch,
}:

buildPythonPackage rec {
  pname = "lineax";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "lineax";
    tag = "v${version}";
    hash = "sha256-HcFI55Ww/y7ZaUkawj7xWSb7VDTBec3u0ulWL8kTm2c=";
  };

  patches = [
    (fetchpatch {
      # Reported upstream: https://github.com/patrick-kidger/lineax/issues/118
      # Fixed by https://github.com/patrick-kidger/lineax/pull/119
      name = "fix-vmap-tests";
      url = "https://github.com/patrick-kidger/lineax/pull/119/commits/d21552ac4c504d7b139ad8e4f15d5f102b54d705.patch";
      hash = "sha256-pBejiqIVNjXi7dXuDBQdAy892wro1WxzwbI7v07N86c=";
    })
  ];

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
    changelog = "https://github.com/patrick-kidger/lineax/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
