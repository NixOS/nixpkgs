{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "essent-dynamic-pricing";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaapp";
    repo = "py-essent-dynamic-pricing";
    tag = version;
    hash = "sha256-jYSyFZ4b6zyfIvT9KkvffH2CteHgy844O76UjUcaTq0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "essent_dynamic_pricing" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    description = "Async client for Essent dynamic energy prices";
    homepage = "https://github.com/jaapp/py-essent-dynamic-pricing";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
