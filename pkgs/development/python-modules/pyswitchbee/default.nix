{
  lib,
  awesomeversion,
  buildPythonPackage,
  aiohttp,
  fetchFromGitHub,
  setuptools,
  packaging,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyswitchbee";
  version = "1.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jafar-atili";
    repo = "pySwitchbee";
    tag = finalAttrs.version;
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

  meta = {
    description = "Library to control SwitchBee smart home device";
    homepage = "https://github.com/jafar-atili/pySwitchbee/";
    changelog = "https://github.com/jafar-atili/pySwitchbee/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
