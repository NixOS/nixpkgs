{
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  lib,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "pysmhi";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gjohansson-ST";
    repo = "pysmhi";
    tag = "v${version}";
    hash = "sha256-n2eDQ9fbELGvO/SYqdrwT+lZNIZs5GgihmrimvI3a1w=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pysmhi" ];

  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/gjohansson-ST/pysmhi/releases/tag/${src.tag}";
    description = "Retrieve open data from SMHI api";
    homepage = "https://github.com/gjohansson-ST/pysmhi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
