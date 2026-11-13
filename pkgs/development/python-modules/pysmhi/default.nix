{
  aiohttp,
  aiointercept,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  lib,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysmhi";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gjohansson-ST";
    repo = "pysmhi";
    tag = finalAttrs.version;
    hash = "sha256-QGpheSXmYWLgrIYg98qBgR2R6pFCH1eB0HQPK1T3/qo=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pysmhi" ];

  nativeCheckInputs = [
    aiointercept
    freezegun
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/gjohansson-ST/pysmhi/releases/tag/${finalAttrs.src.tag}";
    description = "Retrieve open data from SMHI api";
    homepage = "https://github.com/gjohansson-ST/pysmhi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
