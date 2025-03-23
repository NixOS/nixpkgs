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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gjohansson-ST";
    repo = "pysmhi";
    tag = "v${version}";
    hash = "sha256-QwL4WkKrp1CWvJQK/H0iua2Eupe3FvZ4WkYV8OtONhI=";
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
