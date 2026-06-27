{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  aiohttp,
  pydantic,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygti";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "pygti";
    tag = "v${version}";
    hash = "sha256-B+jz91xoN7GiU4PnJTG5Kt1eA4ST63d+ZEgRrr9Xio8=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pygti.auth"
    "pygti.exceptions"
    "pygti.gti"
  ];

  meta = {
    changelog = "https://github.com/vigonotion/pygti/releases/tag/${src.tag}";
    description = "Access public transport information in Hamburg, Germany";
    homepage = "https://github.com/vigonotion/pygti";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
