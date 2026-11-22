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
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skipperro";
    repo = "pajgps-api";
    tag = finalAttrs.version;
    hash = "sha256-i3cEQmy8zr+fZBahY4tzj9jQg2EqwtMTD74JBKiq8aY=";
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
