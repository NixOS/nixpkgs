{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  aiohttp,
  tenacity,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "doorbirdpy";
  version = "3.0.8";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "klikini";
    repo = "doorbirdpy";
    rev = "refs/tags/${version}";
    hash = "sha256-UayXJhfiiwB2aXCa5V1U/LnNiV7KX4lpIG9hNG6iCm0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    tenacity
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "doorbirdpy" ];

  meta = with lib; {
    changelog = "https://gitlab.com/klikini/doorbirdpy/-/tags/${version}";
    description = "Python wrapper for the DoorBird LAN API";
    homepage = "https://gitlab.com/klikini/doorbirdpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
