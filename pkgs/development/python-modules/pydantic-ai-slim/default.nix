{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update,
  writeShellApplication,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  genai-prices,
  griffelib,
  httpx,
  opentelemetry-api,
  pydantic-graph,
  pydantic,
  typing-inspection,

}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-ai-slim";
  version = "2.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9T1y3PARJVPdfVHaAVz1ApPIyCjijxYgvqM/enbgVaU=";
  };

  sourceRoot = "${finalAttrs.src.name}/pydantic_ai_slim";

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    genai-prices
    griffelib
    httpx
    opentelemetry-api
    pydantic-graph
    pydantic
    typing-inspection
  ];

  pythonImportsCheck = [
    "pydantic_ai"
  ];

  doCheck = false;

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "pydantic-ai-updater";
    runtimeInputs = [
      nix-update
    ];
    text = ''
      nix-update --build --commit python3Packages.genai-prices
      nix-update --build --commit python3Packages.pydantic-graph
      nix-update --build python3Packages.pydantic-ai-slim
    '';
  });

  meta = {
    changelog = "https://github.com/pydantic/pydantic-ai/releases/tag/${finalAttrs.src.tag}";
    description = "GenAI Agent Framework, the Pydantic way";
    homepage = "https://github.com/pydantic/pydantic-ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
