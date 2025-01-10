{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  getmac,
  pythonOlder,
  requests,
  setuptools,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "boschshcpy";
  version = "0.2.101";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "tschamm";
    repo = "boschshcpy";
    tag = version;
    hash = "sha256-PUTa4ypq6zmoeNMp5SyqB05H//M2zNVILcjmU5Mzv8M=";
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

  meta = with lib; {
    description = "Python module to work with the Bosch Smart Home Controller API";
    homepage = "https://github.com/tschamm/boschshcpy";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
