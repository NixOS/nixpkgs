{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "energyflip-client";
  version = "0.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dennisschroer";
    repo = "energyflip-client";
    tag = "v${version}";
    hash = "sha256-neuZ6pZWW/Rgexu/iCEymjnxi5l/IuLKPFn6S9U4DgU=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    yarl
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "energyflip" ];

  meta = {
    description = "Library to communicate with the API behind EnergyFlip";
    homepage = "https://github.com/dennisschroer/energyflip-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
