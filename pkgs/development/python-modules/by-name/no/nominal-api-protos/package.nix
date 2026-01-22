{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "nominal-api-protos";
  version = "0.806.0";
  pyproject = true;

  # nixpkgs-update: no auto update
  src = fetchPypi {
    inherit version;
    pname = "nominal_api_protos";
    hash = "sha256-wbMGgW3YYX+MVc525rH6pOk72H7NlmiyEJiFtz+Osoo=";
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
