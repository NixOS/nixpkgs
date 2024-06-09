{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "google-search-results";
  version = "2.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
    hash = "sha256-YDow7K4q+OYAsiY1dXpt8nXa1Lk0+XXmeHjM1kC3gkU=";
  };

  propagatedBuildInputs = [ requests ];

  # almost all tests require an API key or network access
  doCheck = false;

  pythonImportsCheck = [ "serpapi" ];

  meta = with lib; {
    description = "Scrape and search localized results from Google, Bing, Baidu, Yahoo, Yandex, Ebay, Homedepot, youtube at scale using SerpApi.com";
    homepage = "https://github.com/serpapi/google-search-results-python";
    changelog = "https://github.com/serpapi/google-search-results-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
