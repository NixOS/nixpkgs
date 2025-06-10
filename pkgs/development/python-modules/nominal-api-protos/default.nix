{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "nominal-api-protos";
  version = "0.714.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "nominal_api_protos";
    hash = "sha256-YYWZwubF0YgOd6KAKJ1z9/VFZ8Cz7CbyTyDOWEZ29hY=";
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
