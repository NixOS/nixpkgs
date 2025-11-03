{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "librehardwaremonitor-api";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sab44";
    repo = "librehardwaremonitor-api";
    tag = "v${version}";
    hash = "sha256-yYJOizO6blfwRBWD9oFnaein7DK1F8Kl744ErehXU0Q=";
  };

  build-system = [ setuptools ];

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
