{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  conjure-python-client,
}:

# Nominal packages should be updated together
# to ensure compatibility.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "nominal-api";
  version = "0.1072.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "nominal_api";
    hash = "sha256-3LwZRIwIpoaVRaa1R0TGXv187YRdm4uVVrA8zj01dgI=";
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
    maintainers = with lib.maintainers; [
      alkasm
      watwea
    ];
    license = lib.licenses.unfree;
  };
}
