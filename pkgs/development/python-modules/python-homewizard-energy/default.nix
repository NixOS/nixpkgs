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
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "python-homewizard-energy";
  version = "9.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = "python-homewizard-energy";
    tag = "v${version}";
    hash = "sha256-BJCWYxw2FY43VgjeTEzsMp3gs2OQQC60Cew4wZWUf8w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
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

  meta = with lib; {
    description = "Library to communicate with HomeWizard Energy devices";
    homepage = "https://github.com/homewizard/python-homewizard-energy";
    changelog = "https://github.com/homewizard/python-homewizard-energy/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
