{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  aiohttp,
  voluptuous,
}:
buildPythonPackage rec {
  pname = "alphaess";
  version = "0.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CharlesGillanders";
    repo = "alphaess-openAPI";
    tag = version;
    sha256 = "sha256-ECOL1fCJDL9OEDKElw9yAzF5SF3RB/6TrgK26ddtSzw=";
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
