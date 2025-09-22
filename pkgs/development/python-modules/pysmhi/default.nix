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
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gjohansson-ST";
    repo = "pysmhi";
    tag = "v${version}";
    hash = "sha256-9jsSvitxcjH2oFCdSm1203UwG5xjOwQDTaU4Z9Cqs+A=";
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

  meta = {
    changelog = "https://github.com/gjohansson-ST/pysmhi/releases/tag/${src.tag}";
    description = "Retrieve open data from SMHI api";
    homepage = "https://github.com/gjohansson-ST/pysmhi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
