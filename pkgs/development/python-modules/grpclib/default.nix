{
  lib,
  async-timeout,
  buildPythonPackage,
  certifi,
  faker,
  fetchFromGitHub,
  googleapis-common-protos,
  h2,
  multidict,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpclib";
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vmagamedov";
    repo = "grpclib";
    tag = "v${version}";
    hash = "sha256-9ElCIL084B+KihV1AXYJejBletj8y6LnoWRGEj4E1tQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    h2
    multidict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    async-timeout
    faker
    googleapis-common-protos
    certifi
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "grpclib" ];

  meta = {
    description = "Pure-Python gRPC implementation for asyncio";
    homepage = "https://github.com/vmagamedov/grpclib";
    changelog = "https://github.com/vmagamedov/grpclib/blob/v${version}/docs/changelog/index.rst";
    license = lib.licenses.bsd3;
  };
}
