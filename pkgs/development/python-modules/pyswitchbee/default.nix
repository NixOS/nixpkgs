{ lib
, buildPythonPackage
, aiohttp
, fetchFromGitHub
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyswitchbee";
  version = "1.7.3";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jafar-atili";
    repo = "pySwitchbee";
    rev = "refs/tags/${version}";
    hash = "sha256-M3sxxBp4IoqZLX9Lyw35Z0zkV6fDT7AkeDOcdPN5k7w=";
  };

  postPatch = ''
    # https://github.com/jafar-atili/pySwitchbee/pull/2
    substituteInPlace pyproject.toml \
      --replace '"asyncio",' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "switchbee"
  ];

  meta = with lib; {
    description = "Library to control SwitchBee smart home device";
    homepage = "https://github.com/jafar-atili/pySwitchbee/";
    changelog = "https://github.com/jafar-atili/pySwitchbee/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
