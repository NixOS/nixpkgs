{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  getmac,
  requests,
  setuptools,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "boschshcpy";
  version = "0.2.115";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tschamm";
    repo = "boschshcpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mR2TWfq7ItM1WLnnU7fzeWEeK65ENrCuRxzKte+zDZs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    getmac
    requests
    zeroconf
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "boschshcpy" ];

  meta = {
    description = "Python module to work with the Bosch Smart Home Controller API";
    homepage = "https://github.com/tschamm/boschshcpy";
    changelog = "https://github.com/tschamm/boschshcpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
