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

buildPythonPackage rec {
  pname = "boschshcpy";
  version = "0.2.107";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tschamm";
    repo = "boschshcpy";
    tag = version;
    hash = "sha256-JHOaviN8pjG/VcYCZUk7vRTLKCfj5TMCQYo+dNDdX5I=";
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
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
