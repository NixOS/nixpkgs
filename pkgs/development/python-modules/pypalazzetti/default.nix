{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypalazzetti";
  version = "0.1.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dotvav";
    repo = "py-palazzetti-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jDsDa/5QFi4HUSagFHG73+Aj5BPOC8UNO+k7XxLZawk=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "pypalazzetti" ];

  meta = {
    description = "Library to access and control a Palazzetti stove through a Connection Box";
    homepage = "https://github.com/dotvav/py-palazzetti-api";
    changelog = "https://github.com/dotvav/py-palazzetti-api/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
