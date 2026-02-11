{
  lib,
  aiohttp,
  aiolimiter,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mariadb,
  requests,
  tqdm,
  ujson,
}:

buildPythonPackage (finalAttrs: {
  pname = "cpe-search";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ra1nb0rn";
    repo = "cpe_search";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S6VmFy5JSp/yjTjz6VibGGf+49rfhKv9kXM6LPUTnT4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiolimiter
    requests
    tqdm
    ujson
  ];

  optional-dependencies = {
    all = [
      aiohttp
      aiolimiter
      mariadb
      requests
      tqdm
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
    changelog = "https://github.com/ra1nb0rn/cpe_search/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
