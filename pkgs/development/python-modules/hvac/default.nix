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
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-4AVq2QZOeSPodOZ2kBWwMlgLY54pJG9asQRPeVnBx+A=";
=======
    hash = "sha256-G4XjMg6GQt2C8jTbYyU82haagXWJ6CNxPcX8qDEZseI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pyhcl
    requests
  ];

  # Requires running a Vault server
  doCheck = false;

  pythonImportsCheck = [ "hvac" ];

<<<<<<< HEAD
  meta = {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    changelog = "https://github.com/hvac/hvac/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    changelog = "https://github.com/hvac/hvac/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
