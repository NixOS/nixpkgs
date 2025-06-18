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
  version = "0.714.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "nominal_api";
    hash = "sha256-ria37YnFc3nZTV21ggguuhpmmc8q9xqGGcmqimhiN7Y=";
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
