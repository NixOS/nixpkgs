{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  nest-asyncio,
  pydantic,
  python-dotenv,
  requests,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "firecrawl-py";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mendableai";
    repo = "firecrawl";
    tag = "v${version}";
    hash = "sha256-GIde8FiU1/gS3oFfTf7f7Tc4KvDVL873VE5kjyh33Is=";
  };

  sourceRoot = "${src.name}/apps/python-sdk";

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
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
    changelog = "https://github.com/mendableai/firecrawl/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
