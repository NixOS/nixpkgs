{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nest-asyncio,
  pydantic,
  python-dotenv,
  requests,
  websockets,
}:

buildPythonPackage rec {
  pname = "firecrawl-py";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mendableai";
    repo = "firecrawl";
    tag = "v${version}";
    hash = "sha256-6reo89L/f50pNdMEm1nknEotoCyZFO/RBu3ldNUQkhk=";
  };

  sourceRoot = "${src.name}/apps/python-sdk";

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/mendableai/firecrawl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
