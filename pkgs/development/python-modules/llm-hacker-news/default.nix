{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-hacker-news,
}:

buildPythonPackage rec {
  pname = "llm-hacker-news";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-hacker-news";
    tag = version;
    hash = "sha256-pywx9TAN/mnGR6Vv6YsPhLO4R5Geagw/bcydQjvTH5s=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  pythonImportsCheck = [ "llm_hacker_news" ];

  passthru.tests = llm.mkPluginTest llm-hacker-news;

  meta = {
    description = "LLM plugin for pulling content from Hacker News";
    homepage = "https://github.com/simonw/llm-hacker-news";
    changelog = "https://github.com/simonw/llm-hacker-news/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
