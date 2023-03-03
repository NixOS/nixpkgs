{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "energyflip-client";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dennisschroer";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-neuZ6pZWW/Rgexu/iCEymjnxi5l/IuLKPFn6S9U4DgU=";
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

  pythonImportsCheck = [
    "energyflip"
  ];

  meta = with lib; {
    description = "Library to communicate with the API behind EnergyFlip";
    homepage = "https://github.com/dennisschroer/energyflip-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
