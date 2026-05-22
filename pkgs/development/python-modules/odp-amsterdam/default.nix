{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pytz,
  syrupy,
}:

buildPythonPackage rec {
  pname = "odp-amsterdam";
  version = "6.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-odp-amsterdam";
    tag = "v${version}";
    hash = "sha256-vamWelyEcwvYI5I9wmKk8kKc7j0OMer/BKgC0pbN4g0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"0.0.0"' '"${version}"'
    sed -i '/addopts/d' pyproject.toml
  '';

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [ "pytz" ];

  dependencies = [
    aiohttp
    pytz
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "odp_amsterdam" ];

  meta = {
    description = "Python client for getting garage occupancy in Amsterdam";
    homepage = "https://github.com/klaasnicolaas/python-odp-amsterdam";
    changelog = "https://github.com/klaasnicolaas/python-odp-amsterdam/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
