{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pytestCheckHook,
  python-dotenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "pajgps-api";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skipperro";
    repo = "pajgps-api";
    tag = finalAttrs.version;
    hash = "sha256-aYi+VuU7wcQRepDY+bNRUT6EIDMh/zrAfdUC6xanirM=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "pajgps_api" ];

  meta = {
    description = "Python library to interact with the PAJ GPS API";
    homepage = "https://github.com/skipperro/pajgps-api";
    changelog = "https://github.com/skipperro/pajgps-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
