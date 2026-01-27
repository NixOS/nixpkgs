{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  aiohttp,
  voluptuous,
}:
buildPythonPackage rec {
  name = "alphaessopenapi";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "CharlesGillanders";
    repo = "alphaess-openAPI";
    rev = "${version}";
    sha256 = "sha256-ECOL1fCJDL9OEDKElw9yAzF5SF3RB/6TrgK26ddtSzw=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];

  meta = {
    homepage = "https://github.com/CharlesGillanders/alphaess-openAPI";
    description = "This Python library uses the Alpha ESS Open API to retrieve data on your Alpha ESS inverter, photovoltaic panels, and battery if you have one";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
