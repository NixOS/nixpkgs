{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  aiohttp,
  jinja2,
  markupsafe,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "aiohttp-swagger";
  version = "1.0.15";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cr0hn";
    repo = "aiohttp-swagger";
    tag = version;
    hash = "sha256-M43sNpbXWXFRTd549cZhvhO35nBB6OH+ki36BzSk87Q=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/cr0hn/aiohttp-swagger/pull/108/commits/a4be5331c8a50d46ea64c4c69e00292300245f3b.patch";
      hash = "sha256-lPrXzctXl6aNr+SIUpqAFhq49hMeoqTFfckvh5awgPQ=";
    })
    (fetchpatch {
      url = "https://github.com/cr0hn/aiohttp-swagger/pull/108/commits/968f40b23e5bf5cc3e19053c764806574026d3e7.patch";
      hash = "sha256-tkZ2PbRuciFzV6bx/1HYn9ZWbP/4bEmBHL0ObPz4fMQ=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    jinja2
    markupsafe
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
  ];

  pythonRelaxDeps = [
    "markupsafe"
    "jinja2"
  ];

  pythonImportsCheck = [ "aiohttp_swagger" ];

  meta = {
    description = "Swagger API Documentation builder for aiohttp";
    homepage = "https://github.com/cr0hn/aiohttp-swagger";
    license = lib.licenses.mit;
  };
}
