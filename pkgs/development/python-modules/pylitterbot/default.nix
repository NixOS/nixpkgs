{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  deepdiff,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  pycognito,
  pyjwt,
  pytest-aiohttp,
  pytest-freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2024.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = "pylitterbot";
    tag = "v${version}";
    hash = "sha256-oQuEo0np+e+HfsQoWbv84BNpxNJQO3ZjocaCfllqkts=";
  };

  pythonRelaxDeps = [ "deepdiff" ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    deepdiff
    pycognito
    pyjwt
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylitterbot" ];

  meta = {
    description = "Modulefor controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    changelog = "https://github.com/natekspencer/pylitterbot/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
