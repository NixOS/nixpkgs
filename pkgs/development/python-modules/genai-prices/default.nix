{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  httpx,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "genai-prices";
  version = "0.0.57";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "genai-prices";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gEviMu89IL4qSU4/wjGhLo8l1kA5N2alGp+/VcQpEHM=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python";

  build-system = [
    uv-build
  ];

  dependencies = [
    httpx
    pydantic
  ];

  pythonImportsCheck = [
    "genai_prices"
  ];

  doCheck = false; # no tests

  meta = {
    description = "Calculate prices for calling LLM inference APIs";
    homepage = "https://github.com/pydantic/genai-prices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
