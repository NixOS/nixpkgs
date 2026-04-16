{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-technove";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Moustachauve";
    repo = "pytechnove";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m1h3l9xw7Xe5iPB2pa0fqaRteBWq738HuBIvIZuPZbE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
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
    changelog = "https://github.com/Moustachauve/pytechnove/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
