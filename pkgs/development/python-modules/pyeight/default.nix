{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyeight";
  version = "0.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyEight";
    rev = version;
    hash = "sha256-JYmhEZQw11qPNV2jZhP+0VFb387kNom70R3C13PM7kc=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyeight" ];

  meta = {
    description = "Python library to interface with the Eight Sleep API";
    homepage = "https://github.com/mezz64/pyEight";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
