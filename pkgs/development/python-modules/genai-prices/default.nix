{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  httpx2,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "genai-prices";
  version = "0.0.67";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "genai-prices";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MIWUpPHunKGKSLn/gDWWDseDVqqd2dll5aprMo5kcaQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python";

  build-system = [
    uv-build
  ];

  dependencies = [
    httpx2
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
