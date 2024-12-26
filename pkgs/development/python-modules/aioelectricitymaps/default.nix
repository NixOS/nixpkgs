{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "aioelectricitymaps";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "aioelectricitymaps";
    rev = "refs/tags/v${version}";
    hash = "sha256-l6D5Cr2d89n+Ac5V5geBUY0sOiEO3sci9244K0MI+dc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aioelectricitymaps" ];

  # https://github.com/jpbede/aioelectricitymaps/pull/415
  pytestFlagsArray = [ "--snapshot-update" ];

  meta = with lib; {
    description = "Module for interacting with Electricity maps";
    homepage = "https://github.com/jpbede/aioelectricitymaps";
    changelog = "https://github.com/jpbede/aioelectricitymaps/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
