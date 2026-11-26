{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  requests,
  ciso8601,
}:

buildPythonPackage rec {
  pname = "dwdwfsapi";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xj1SUPmtZ773+trXkdvZK+uUF1+wmUnMlRltsCmhtCM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    ciso8601
  ];

  # All tests require network access
  doCheck = false;

  pythonImportsCheck = [ "dwdwfsapi" ];

  meta = {
    description = "Python client to retrieve data provided by DWD via their geoserver WFS API";
    homepage = "https://github.com/stephan192/dwdwfsapi";
    changelog = "https://github.com/stephan192/dwdwfsapi/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
}
