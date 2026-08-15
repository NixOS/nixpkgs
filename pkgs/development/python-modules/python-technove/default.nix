{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-backoff,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-technove";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Moustachauve";
    repo = "pytechnove";
    tag = "v${version}";
    hash = "sha256-Hbwrfib+ugjpYnVCuZZfbr+9eBeLN4q7WE5G2xGD0nk=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    python-backoff
    cachetools
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "technove" ];

  meta = {
    description = "Python library to interact with TechnoVE local device API";
    homepage = "https://github.com/Moustachauve/pytechnove";
    changelog = "https://github.com/Moustachauve/pytechnove/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
