{
  lib,
  aiohttp,
  aresponses,
  async-timeout,
  awesomeversion,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  multidict,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-homewizard-energy";
  version = "10.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = "python-homewizard-energy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/bz/KM6kCLciHRcPifd5F1P6Agzzb2ULxEzWP9xbfwo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
    awesomeversion
    backoff
    mashumaro
    multidict
    orjson
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "homewizard_energy" ];

  meta = {
    description = "Library to communicate with HomeWizard Energy devices";
    homepage = "https://github.com/homewizard/python-homewizard-energy";
    changelog = "https://github.com/homewizard/python-homewizard-energy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
