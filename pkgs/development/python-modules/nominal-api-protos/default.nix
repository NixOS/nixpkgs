{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  grpcio-tools,
  setuptools,
  protobuf,
}:

# Nominal packages should be updated together
# to ensure compatibility.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "nominal-api-protos";
  version = "0.1072.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "nominal_api_protos";
    hash = "sha256-8qo5ZL/mxhdILGfeFx3UUoWrHWSu0Dol1MclGjQEMTw=";
  };

  build-system = [
    grpcio-tools
    setuptools
  ];

  dependencies = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [ "nominal_api_protos" ];

  meta = {
    description = "Generated protobuf client for the Nominal API";
    homepage = "https://pypi.org/project/nominal-api-protos/";
    maintainers = with lib.maintainers; [
      alkasm
      watwea
    ];
    license = lib.licenses.unfree;
  };
}
