{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  hatchling,
}:

buildPythonPackage rec {
  pname = "librehardwaremonitor-api";
  version = "1.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sab44";
    repo = "librehardwaremonitor-api";
    tag = "v${version}";
    hash = "sha256-RGtR/VSamfpSpS5TN9nUPCjzkwp5eUcV41Q8R76MDAA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "librehardwaremonitor_api" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python API client for LibreHardwareMonitor";
    homepage = "https://github.com/Sab44/librehardwaremonitor-api";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
