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
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaapp";
    repo = "py-essent-dynamic-pricing";
    tag = "v${version}";
    hash = "sha256-98dh9XNXIVDI0w0/RqEGnDbDpQQoaZz/TvMIl6t3c3o=";
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
    changelog = "https://github.com/jaapp/py-essent-dynamic-pricing/releases/tag/${src.tag}";
    description = "Async client for Essent dynamic energy prices";
    homepage = "https://github.com/jaapp/py-essent-dynamic-pricing";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
