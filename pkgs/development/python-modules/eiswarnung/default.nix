{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  pytz,
  yarl,
}:

buildPythonPackage rec {
  pname = "eiswarnung";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-eiswarnung";
    tag = "v${version}";
    hash = "sha256-/61qrRfD7/gaEcvFot34HYXOVLWwTDi/fvcgHDTv9u0=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"0.0.0"' '"${version}"'
  '';

  pythonRelaxDeps = [ "pytz" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    pytz
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "eiswarnung" ];

  meta = with lib; {
    description = "Module for getting Eiswarning API forecasts";
    homepage = "https://github.com/klaasnicolaas/python-eiswarnung";
    changelog = "https://github.com/klaasnicolaas/python-eiswarnung/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
