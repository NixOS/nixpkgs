{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-pep517,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "imeon-inverter-api";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Imeon-Inverters-for-Home-Assistant";
    repo = "inverter-api";
    tag = version;
    hash = "sha256-8tecWWDYFq+kAqWM9vKhM15LKnEVqaDBkH6jh0xwIsE=";
  };

  build-system = [ pdm-pep517 ];

  pythonRemoveDeps = [
    # https://github.com/Imeon-Inverters-for-Home-Assistant/inverter-api/pull/1
    "async-timeout"
  ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "imeon_inverter_api" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/Imeon-Inverters-for-Home-Assistant/inverter-api/releases/tag/${src.tag}";
    description = "Standalone API to collect data from the Imeon Energy Inverters that uses HTTP POST/GET";
    homepage = "https://github.com/Imeon-Inverters-for-Home-Assistant/inverter-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
