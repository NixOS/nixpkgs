{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  aiohttp,
  voluptuous,
}:
buildPythonPackage rec {
  pname = "alphaessopenapi";
  version = "0.0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CharlesGillanders";
    repo = "alphaess-openAPI";
    tag = version;
    hash = "sha256-wdwA1MIQrkZCT4zIf8WXyq0+F+peC/auVtjDJ8ZZyxE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    voluptuous
  ];

  pythonImportsCheck = [
    "alphaess"
  ];

  meta = {
    homepage = "https://github.com/CharlesGillanders/alphaess-openAPI";
    description = "Library that uses the Alpha ESS Open API to retrieve data on your Alpha ESS inverter, photovoltaic panels, and battery";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
