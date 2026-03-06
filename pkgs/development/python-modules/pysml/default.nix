{
  lib,
  aiohttp,
  bitstring,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyserial-asyncio-fast,
}:

buildPythonPackage rec {
  pname = "pysml";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mtdcr";
    repo = "pysml";
    tag = version;
    hash = "sha256-cJOf+O/Q+CfX26XQixHEZ/+N7+YsoPadxk/0Zeob2f8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    bitstring
    pyserial-asyncio-fast
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sml" ];

  meta = {
    description = "Python library for EDL21 smart meters using Smart Message Language (SML)";
    homepage = "https://github.com/mtdcr/pysml";
    changelog = "https://github.com/mtdcr/pysml/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
