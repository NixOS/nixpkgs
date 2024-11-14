{
  lib,
  aiohttp,
  async-timeout,
  bitstring,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyserial-asyncio,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysml";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = "pysml";
    rev = "refs/tags/${version}";
    hash = "sha256-G4t0cHbJWMmDODeldj064SlKGagOfUnnRiGRwLu1bF0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
    bitstring
    pyserial-asyncio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sml" ];

  meta = with lib; {
    description = "Python library for EDL21 smart meters using Smart Message Language (SML)";
    homepage = "https://github.com/mtdcr/pysml";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
