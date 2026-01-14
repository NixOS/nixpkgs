{
  lib,
  aiohttp,
  aiolimiter,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mariadb,
  requests,
  ujson,
}:

buildPythonPackage rec {
  pname = "cpe-search";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ra1nb0rn";
    repo = "cpe_search";
    tag = "v${version}";
    hash = "sha256-gCWKVSVDJNspRwDzHi7+vUETGErWYs3jlpsqkOqSY4I=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiolimiter
    requests
    ujson
  ];

  optional-dependencies = {
    all = [
      aiohttp
      aiolimiter
      mariadb
      requests
      ujson
    ];
    mariadb = [
      mariadb
    ];
  };

  # Tests requires DB and API access
  doCheck = false;

  pythonImportsCheck = [ "cpe_search" ];

  meta = {
    description = "Search for Common Platform Enumeration (CPE) strings using software names and titles";
    homepage = "https://github.com/ra1nb0rn/cpe_search";
    changelog = "https://github.com/ra1nb0rn/cpe_search/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
