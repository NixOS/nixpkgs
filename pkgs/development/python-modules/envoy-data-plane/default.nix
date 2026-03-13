{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  betterproto,
  grpcio-tools,
}:

buildPythonPackage (finalAttrs: {
  pname = "envoy-data-plane";
  version = "1.0.3";
  pyproject = true;

  # Version 2.0.0 appears to be an empty archive and apache-beam requires envoy-data-planes<2.0.0
  # nixpkgs-update: no auto update
  src = fetchPypi {
    pname = "envoy_data_plane";
    inherit (finalAttrs) version;
    hash = "sha256-UkSrtENDXjEtvEJldgZ5UHHkxK3rOqV3mmifrLGo538=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "betterproto"
  ];
  dependencies = [
    betterproto
    grpcio-tools
  ];

  pythonImportsCheck = [ "envoy_data_plane" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Python dataclasses for the Envoy Data-Plane-API";
    homepage = "https://pypi.org/project/envoy_data_plane/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
