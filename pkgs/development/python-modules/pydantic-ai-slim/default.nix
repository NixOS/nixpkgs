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
  anyio,
  genai-prices,
  griffelib,
  httpx2,
  opentelemetry-api,
  pydantic-graph,
  pydantic,
  typing-inspection,

}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-ai-slim";
  version = "2.52.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7AI/a0xwWGTl+KMNYVC3pL4AG8qfLeRbeZyd3ZsK1JA=";
  };

  sourceRoot = "${finalAttrs.src.name}/pydantic_ai_slim";

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    anyio
    genai-prices
    griffelib
    httpx2
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
