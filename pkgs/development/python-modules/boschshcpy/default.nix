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
  version = "0.4.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tschamm";
    repo = "boschshcpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a0ckgCctTzSPI/EUxcUHiQ1fLH6cVZM5qLLdyxc+tII=";
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
