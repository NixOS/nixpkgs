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
  version = "0.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LmybrMHHWsLd6Y2xMqJ8g65SQCsysBGxeL43qouo3SM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    bitstring
    pyserial-asyncio
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "sml" ];

  meta = with lib; {
    description = "Python library for EDL21 smart meters using Smart Message Language (SML)";
    homepage = "https://github.com/mtdcr/pysml";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
