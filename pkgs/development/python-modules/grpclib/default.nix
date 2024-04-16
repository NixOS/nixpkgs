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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpclib";
  version = "0.4.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vmagamedov";
    repo = "grpclib";
    rev = "refs/tags/v${version}";
    hash = "sha256-5221hVjD0TynCsTdruiUZkTsb7uOi49tZ8M/YqdWreE=";
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

  pythonImportsCheck = [ "grpclib" ];

  meta = with lib; {
    description = "Pure-Python gRPC implementation for asyncio";
    homepage = "https://github.com/vmagamedov/grpclib";
    changelog = "https://github.com/vmagamedov/grpclib/blob/v${version}/docs/changelog/index.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nikstur ];
  };
}
