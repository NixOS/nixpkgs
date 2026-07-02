{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "pypaperless";
  version = "5.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tb1337";
    repo = "paperless-api";
    tag = "v${version}";
    hash = "sha256-hlXoV7eusK3Zl8VVP7U6RIHWj2pisLMCasqECXmi3Qk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "pypaperless" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/tb1337/paperless-api/releases/tag/${src.tag}";
    description = "Little api client for paperless(-ngx)";
    homepage = "https://github.com/tb1337/paperless-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
