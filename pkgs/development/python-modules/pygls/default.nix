{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  lsprotocol,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  typeguard,
  websockets,
}:

buildPythonPackage rec {
  pname = "pygls";
  version = "2.0.0a6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = "pygls";
    tag = "v${version}";
    hash = "sha256-S3MKg9zkjf6SXhLzUBgy3HvPkLQPgA57Ne9fqW3GHYo=";
  };

  pythonRelaxDeps = [
    "lsprotocol"
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    lsprotocol
    typeguard
  ];

  optional-dependencies = {
    ws = [ websockets ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Darwin issue: OSError: [Errno 24] Too many open files
    ulimit -n 1024
  '';

  pythonImportsCheck = [ "pygls" ];

  meta = with lib; {
    description = "Pythonic generic implementation of the Language Server Protocol";
    homepage = "https://github.com/openlawlibrary/pygls";
    changelog = "https://github.com/openlawlibrary/pygls/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
