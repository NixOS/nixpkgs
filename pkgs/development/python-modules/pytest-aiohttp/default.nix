{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  aiohttp,
  pytest,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-aiohttp";
  version = "1.1.0";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "pytest-aiohttp";
    tag = "v${version}";
    hash = "sha256-5xUY3SVaoZzCZE/qfAP4R49HbtBMYj5jMN5viLEzEkM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [
    aiohttp
    pytest-asyncio
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [ "-Wignore::pytest.PytestDeprecationWarning" ];

  meta = with lib; {
    homepage = "https://github.com/aio-libs/pytest-aiohttp/";
    changelog = "https://github.com/aio-libs/pytest-aiohttp/blob/${src.rev}/CHANGES.rst";
    description = "Pytest plugin for aiohttp support";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
