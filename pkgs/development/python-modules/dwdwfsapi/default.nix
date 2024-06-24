{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  requests,
  ciso8601,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dwdwfsapi";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7dIVD+4MiYtsjAM5j67MlbiUN2Q5DpK6bUU0ZuHN2rk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    ciso8601
  ];

  # All tests require network access
  doCheck = false;

  pythonImportsCheck = [ "dwdwfsapi" ];

  meta = with lib; {
    description = "Python client to retrieve data provided by DWD via their geoserver WFS API";
    homepage = "https://github.com/stephan192/dwdwfsapi";
    changelog = "https://github.com/stephan192/dwdwfsapi/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
  };
}
