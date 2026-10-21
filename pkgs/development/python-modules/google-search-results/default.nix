{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-search-results";
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serpapi";
    repo = "google-search-results-python";
    tag = version;
    hash = "sha256-2GRhBaRE0KHNFsdMrIC87dx6yMzql+QQFSSm2Gf7xHU=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # almost all tests require an API key or network access
  doCheck = false;

  pythonImportsCheck = [ "serpapi" ];

  meta = {
    description = "Scrape and search localized results from Google, Bing, Baidu, Yahoo, Yandex, Ebay, Homedepot, youtube at scale using SerpApi.com";
    homepage = "https://github.com/serpapi/google-search-results-python";
    changelog = "https://github.com/serpapi/google-search-results-python/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
