{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  forbiddenfruit,
  pytestCheckHook,
  pytest-asyncio,
  requests,
}:

buildPythonPackage rec {
  pname = "blockbuster";
  version = "1.5.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cbornet";
    repo = "blockbuster";
    tag = "v${version}";
    hash = "sha256-RIy5xjTpw6Bsxo1oiKQ5fbrBpkL8eujOY85G2GW2lrI=";
  };

  build-system = [ hatchling ];

  dependencies = [ forbiddenfruit ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    requests
  ];

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # network access
    "test_ssl_socket"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "blockbuster" ];

  meta = {
    description = "Utility to detect blocking calls in the async event loop";
    homepage = "https://github.com/cbornet/blockbuster";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
