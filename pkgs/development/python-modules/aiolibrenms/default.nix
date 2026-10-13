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
  syrupy_6,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiolibrenms";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "aiolibrenms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2f52QmCcwk5VX7+Wy21agNmkyjQ94jAs8P5v0n/DAHE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.0.0" setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    aiointercept
    pytest-asyncio
    pytestCheckHook
    syrupy_6
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
