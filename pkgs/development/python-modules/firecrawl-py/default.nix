{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  nest-asyncio,
  pydantic,
  python-dotenv,
  requests,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "firecrawl-py";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mendableai";
    repo = "firecrawl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wP9fA5sHYwO/K/7dYL6l7R7Us6aiY49IYVUPkY/7sZQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/apps/python-sdk";

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    httpx
    nest-asyncio
    pydantic
    python-dotenv
    requests
    websockets
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "firecrawl" ];

  meta = {
    description = "Turn entire websites into LLM-ready markdown or structured data. Scrape, crawl and extract with a single API";
    homepage = "https://firecrawl.dev";
    changelog = "https://github.com/mendableai/firecrawl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
