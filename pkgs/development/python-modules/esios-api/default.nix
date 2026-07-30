{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "esios-api";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chiro79";
    repo = "esios-api";
    tag = finalAttrs.version;
    hash = "sha256-ZmU1D+W3ah4LUwgHwaS6NJpfKPLSRgIC8psUXTy/muM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry_core>=2.4.0" "poetry_core"
  '';

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "esios_api" ];

  meta = {
    description = "Retrieval of Spanish Electricity hourly prices (PVPC)";
    homepage = "https://github.com/chiro79/esios-api";
    changelog = "https://github.com/chiro79/esios-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
