{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  poetry-core,
  poetry-dynamic-versioning,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  time-machine,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-air-quality-api";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thomas55555";
    repo = "python-google-air-quality-api";
    tag = finalAttrs.version;
    hash = "sha256-hgdK7Rrw/iELRE+vSuwsRUzLDT8qE2Dhxqd4bAgxays=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
    time-machine
  ];

  pythonImportsCheck = [ "google_air_quality_api" ];

  meta = {
    changelog = "https://github.com/Thomas55555/python-google-air-quality-api/releases/tag/${finalAttrs.version}";
    description = "Python client library for the Google Air Quality API";
    homepage = "https://github.com/Thomas55555/python-google-air-quality-api";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
