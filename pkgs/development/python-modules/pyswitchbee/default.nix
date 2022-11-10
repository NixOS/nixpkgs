{ lib
, buildPythonPackage
, aiohttp
, fetchFromGitHub
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyswitchbee";
  version = "1.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jafar-atili";
    repo = "pySwitchbee";
    rev = "refs/tags/${version}";
    hash = "sha256-MDutpeHI6MW1VwCRTPJK/y08ee4eidOHluMf6lPQfEk=";
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
