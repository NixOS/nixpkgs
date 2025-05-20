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
  version = "1.5.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cbornet";
    repo = "blockbuster";
    tag = "v${version}";
    hash = "sha256-AxRnP8/fIae5ovWQVpfs3ZLIIkxXqVZmuhGjPTX5B/g=";
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
    maintainers = with lib.maintainers; [ ];
  };
}
