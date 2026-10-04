{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  genai-prices,
  httpx,
  json-repair,
  pydantic-ai-slim,
}:

# Update together with pydantic-ai-slim
# nixpkgs-update: no auto update

buildPythonPackage (finalAttrs: {
  pname = "pydantic-ai-harness";
  version = "2.54.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fkE2rww4xoJgeGCF/MP4ijZySTcU411NriIVa7w6NXs=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/pydantic_ai_harness";

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    genai-prices
    httpx
    json-repair
    pydantic-ai-slim
  ];

  # remove when #567678 is merged
  pythonRelaxDeps = [
    "json-repair"
  ];

  pythonImportsCheck = [ "pydantic_ai_harness" ];

  meta = {
    description = "The official capability library and harness for Pydantic AI";
    homepage = "https://github.com/pydantic/pydantic-ai";
    changelog = "https://github.com/pydantic/pydantic-ai/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
  };
})
