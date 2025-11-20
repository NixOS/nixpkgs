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
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sab44";
    repo = "librehardwaremonitor-api";
    tag = "v${version}";
    hash = "sha256-dyhS7vb+qcumtWZsj3G3x66KhHUVDQxMG8+2GngkK70=";
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
