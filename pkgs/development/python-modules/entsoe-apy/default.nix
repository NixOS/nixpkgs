{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest,
  httpx,
  loguru,
  xsdata-pydantic,
}:

buildPythonPackage rec {
  pname = "entsoe-apy";
  version = "0.3.3";

  src = fetchPypi {
    pname = "entsoe_apy";
    inherit version;
    hash = "sha256-vmpJ7bjVXvPNqDgjaqsSFYrr05e55hDQEqmMuOoVIHQ=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    httpx
    loguru
    xsdata-pydantic
  ];

  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [
    "entsoe"
  ];

  # Metadata
  meta = with lib; {
    description = "Python Package to Query the ENTSO-E API";
    homepage = "https://github.com/berrij/entsoe-apy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ berrij ];
    platforms = platforms.all;
  };
}
