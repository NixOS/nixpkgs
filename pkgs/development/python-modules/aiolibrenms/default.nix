{
  lib,
  aiohttp,
  aiointercept,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiolibrenms";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "aiolibrenms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mfOLB2br4RZHl4ky1vZDcSmh6szzDKvnGawHMpxWihg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    aiointercept
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aiolibrenms" ];

  meta = {
    description = "Asynchronous library to fetch data from a LibreNMS instance";
    homepage = "https://github.com/mib1185/aiolibrenms";
    changelog = "https://github.com/mib1185/aiolibrenms/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
