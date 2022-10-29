{ lib
, buildPythonPackage
, aiohttp
, fetchFromGitHub
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyswitchbee";
  version = "1.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jafar-atili";
    repo = "pySwitchbee";
    rev = "refs/tags/${version}";
    hash = "sha256-ZAe47Oxw5n6OM/PRKz7OR8yzi/c9jnXeOYNjCbs0j1E=";
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
    # https://github.com/jafar-atili/pySwitchbee/issues/1
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ fab ];
  };
}
