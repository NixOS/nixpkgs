{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  jinja2,
  markupsafe,
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

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    jinja2
    markupsafe
    pyyaml
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
