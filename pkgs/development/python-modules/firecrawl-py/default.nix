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
  version = "4.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mendableai";
    repo = "firecrawl";
    # The Python SDK version is decoupled from the firecrawl monorepo tags.
    tag = "v2.11.226";
    hash = "sha256-htBM3ywHDMSnJhtbPyQOWLkUtSGSWMIPHpNQ7PNA3Bo=";
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
