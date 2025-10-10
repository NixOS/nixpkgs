{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  httpx,
}:

buildPythonPackage rec {
  pname = "httpx-aiohttp";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karpetrosyan";
    repo = "httpx-aiohttp";
    tag = version;
    hash = "sha256-Fdu8aKsXWggRkc/512OBEiEwWNAajrhjfG/+v4+cows=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "requires = [\"hatchling\", \"hatch-fancy-pypi-readme\"]" \
      "requires = [\"hatchling\"]"
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    aiohttp
    httpx
  ];

  pythonImportsCheck = [
    "httpx_aiohttp"
  ];

  meta = {
    description = "Transports for httpx to work atop aiohttp";
    homepage = "https://github.com/karpetrosyan/httpx-aiohttp/";
    changelog = "https://github.com/karpetrosyan/httpx-aiohttp/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
