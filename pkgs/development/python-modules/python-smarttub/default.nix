{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  inflection,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "python-smarttub";
  version = "0.0.47";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdz";
    repo = "python-smarttub";
    tag = "v${version}";
    hash = "sha256-jKNXViqyRFPeHmoUGL9BGUUcVTQ1w3uJy7J8OlFikPw=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    aiohttp
    inflection
    pyjwt
    python-dateutil
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "smarttub" ];

  meta = {
    description = "Python API for SmartTub enabled hot tubs";
    homepage = "https://github.com/mdz/python-smarttub";
    changelog = "https://github.com/mdz/python-smarttub/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
