{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-citybikes";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eskerda";
    repo = "python-citybikes";
    tag = version;
    hash = "sha256-it/QCUwNc6g88IrtMTS8wr/t4Apb2ovSheufOnu4fCM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    requests
  ];

  pythonImportsCheck = [ "citybikes" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    responses
  ];

  meta = {
    description = "Client interface for the Citybikes API";
    homepage = "https://github.com/eskerda/python-citybikes";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
