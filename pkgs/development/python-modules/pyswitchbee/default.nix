{
  lib,
  awesomeversion,
  buildPythonPackage,
  aiohttp,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  packaging,
}:

buildPythonPackage rec {
  pname = "pyswitchbee";
  version = "1.8.3";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jafar-atili";
    repo = "pySwitchbee";
    tag = version;
    hash = "sha256-at/HCY6htUz1ej09XPrb2QEyoiOWhIEpgSwJange1cU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
    packaging
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "switchbee" ];

  meta = with lib; {
    description = "Library to control SwitchBee smart home device";
    homepage = "https://github.com/jafar-atili/pySwitchbee/";
    changelog = "https://github.com/jafar-atili/pySwitchbee/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
