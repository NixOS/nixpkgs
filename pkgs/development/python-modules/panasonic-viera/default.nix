{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  pycryptodome,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "panasonic-viera";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "florianholzapfel";
    repo = "panasonic-viera";
    tag = version;
    hash = "sha256-f/FLM6xoJwRZwq8Q6uf9W+fJN96wE6HvJozaNVmORtg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    pycryptodome
    xmltodict
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "panasonic_viera" ];

  meta = {
    changelog = "https://github.com/florianholzapfel/panasonic-viera/releases/tag/${src.tag}";
    description = "Library to control Panasonic Viera TVs";
    homepage = "https://github.com/florianholzapfel/panasonic-viera";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
