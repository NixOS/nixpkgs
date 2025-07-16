{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "nominal-api-protos";
  version = "0.708.0";
  pyproject = true;

  # nixpkgs-update: no auto update
  src = fetchPypi {
    inherit version;
    pname = "nominal_api_protos";
    hash = "sha256-EYyBRmmCq4OA6xgf4JpajUtlJClkxxPn48Wmmy2mqN4=";
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
