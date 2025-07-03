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
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tb1337";
    repo = "paperless-api";
    tag = "v${version}";
    hash = "sha256-q2LQiO/9AGROczcKrfatO3P96Fvkdn0HqEDlUbRfhaE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "aiohttp"
    "yarl"
  ];

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
