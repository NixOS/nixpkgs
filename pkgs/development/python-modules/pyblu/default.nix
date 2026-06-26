{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  lxml,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyblu";
  version = "2.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LouisChrist";
    repo = "pyblu";
    tag = "v${version}";
    hash = "sha256-qLB9o40tRYgmbYJEEx8r3SodH1hB8MM4yLXbdKIs/xA=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    lxml
  ];

  pythonImportsCheck = [ "pyblu" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/LouisChrist/pyblu/releases/tag/${src.tag}";
    description = "BluOS API client";
    homepage = "https://github.com/LouisChrist/pyblu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
