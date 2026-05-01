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
  version = "1.5.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cbornet";
    repo = "blockbuster";
    tag = "v${version}";
    hash = "sha256-1+Q1IdJXqLAy7kIcVU38TC3dtMeWAn7YOLyGrjCkxD0=";
  };

  build-system = [ hatchling ];

  dependencies = [ forbiddenfruit ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    requests
  ];

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
