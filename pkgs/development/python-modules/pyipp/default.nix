{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  deepmerge,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "pyipp";
  version = "0.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-ipp";
    tag = version;
    hash = "sha256-YlIc/FNM3SdYQj0DN0if3R7h0383V5CHGpD7FHErWhA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
    deepmerge
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyipp" ];

  meta = {
    changelog = "https://github.com/ctalkington/python-ipp/releases/tag/${version}";
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/ctalkington/python-ipp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
