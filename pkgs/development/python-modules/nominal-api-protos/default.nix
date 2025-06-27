{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "nominal-api-protos";
  version = "0.739.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "nominal_api_protos";
    hash = "sha256-Ox28B5TJHHn2rUkndqyCPF+couLtb7pSDlCb4PpznwY=";
  };

  build-system = [ setuptools ];

  dependencies = [ protobuf ];

  pythonImportsCheck = [ "nominal_api_protos" ];

  meta = {
    description = "Generated protobuf client for the Nominal API";
    homepage = "https://pypi.org/project/nominal-api-protos/";
    maintainers = with lib.maintainers; [ alkasm ];
    license = lib.licenses.unfree;
  };
}
