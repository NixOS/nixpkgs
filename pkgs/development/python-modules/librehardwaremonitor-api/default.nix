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
  version = "1.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sab44";
    repo = "librehardwaremonitor-api";
    tag = "v${version}";
    hash = "sha256-GAJgLrfYhkdafk0DSgcNgXQ2vjtBf/kOEkkRw7i9rlE=";
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
