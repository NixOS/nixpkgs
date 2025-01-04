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
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = "pygls";
    tag = "v${version}";
    hash = "sha256-AvrGoQ0Be1xKZhFn9XXYJpt5w+ITbDbj6NFZpaDPKao=";
  };

  pythonRelaxDeps = [
    # https://github.com/openlawlibrary/pygls/pull/432
    "lsprotocol"
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "pygls" ];

  meta = with lib; {
    description = "Pythonic generic implementation of the Language Server Protocol";
    homepage = "https://github.com/openlawlibrary/pygls";
    changelog = "https://github.com/openlawlibrary/pygls/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
