{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  curl-cffi,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "ha-garmin";
  version = "0.1.49";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "ha-garmin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6qYFeyLlW5udr0paOz1tVLm0TsaLwEvkaFVILan4oNQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    curl-cffi
    pydantic
    requests
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ha_garmin" ];

  meta = {
    description = "Python client for Garmin Connect API, designed for Home Assistant integration";
    homepage = "https://github.com/cyberjunky/ha-garmin";
    changelog = "https://github.com/cyberjunky/ha-garmin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
