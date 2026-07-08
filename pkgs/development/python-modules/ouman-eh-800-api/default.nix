{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "ouman-eh-800-api";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "Markus98";
    repo = "ouman-eh-800-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lY6aC2d31M4I5O1J9vIBH83MMiJ941cMixTsGP5I0OM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.21,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ouman_eh_800_api" ];

  meta = {
    description = "Async client for communicating with the Ouman EH-800 heating controller";
    homepage = "https://github.com/Markus98/ouman-eh-800-api";
    changelog = "https://github.com/Markus98/ouman-eh-800-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
