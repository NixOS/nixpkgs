{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyhcl,
  requests,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "2.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4AVq2QZOeSPodOZ2kBWwMlgLY54pJG9asQRPeVnBx+A=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pyhcl
    requests
  ];

  # Requires running a Vault server
  doCheck = false;

  pythonImportsCheck = [ "hvac" ];

  meta = {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    changelog = "https://github.com/hvac/hvac/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
