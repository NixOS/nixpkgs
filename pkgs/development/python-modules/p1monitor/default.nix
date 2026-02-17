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
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "p1monitor";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-p1monitor";
    tag = "v${version}";
    hash = "sha256-u+hjMTL51GWqYYHOxUjr7D6Q6MfGJhHZ6XsbE1fOF+A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "p1monitor" ];

  meta = {
    description = "Module for interacting with the P1 Monitor";
    homepage = "https://github.com/klaasnicolaas/python-p1monitor";
    changelog = "https://github.com/klaasnicolaas/python-p1monitor/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
