{ lib
, buildPythonPackage
, aiohttp
, fetchFromGitHub
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyswitchbee";
  version = "1.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jafar-atili";
    repo = "pySwitchbee";
    rev = "refs/tags/${version}";
    hash = "sha256-5Mc70yi9Yj+8ye81v9NbKZnNoD5PQmBVAiYF5IM5ix8=";
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
