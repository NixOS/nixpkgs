{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pyblu";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LouisChrist";
    repo = "pyblu";
    rev = "refs/tags/v${version}";
    hash = "sha256-Pj0L9D5j+5koqhbpr4maa8aLGka1FghKkMEbyKi/D3E=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    xmltodict
  ];

  pythonImportsCheck = [ "pyblu" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    description = "BluOS API client";
    homepage = "https://github.com/LouisChrist/pyblu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
