{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  conjure-python-client,
}:

buildPythonPackage rec {
  pname = "nominal-api";
  version = "0.708.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "nominal_api";
    hash = "sha256-gaMQ4bLhdBkDTUoHP5Cb0vS5emNcYga5eTvV2TEWQiU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    conjure-python-client
  ];

  pythonImportsCheck = [ "nominal_api" ];

  meta = {
    description = "Generated conjure client for the Nominal API";
    homepage = "https://pypi.org/project/nominal-api/";
    maintainers = with lib.maintainers; [ alkasm ];
    license = lib.licenses.unfree;
  };
}
