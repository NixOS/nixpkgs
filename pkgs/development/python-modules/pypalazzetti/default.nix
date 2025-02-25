{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "pypalazzetti";
  version = "0.1.19";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dotvav";
    repo = "py-palazzetti-api";
    tag = "v${version}";
    hash = "sha256-Bmx4CU6bx5FVR7xdDxrtVSXunthi2s2Esj1FtSjh61U=";
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
    changelog = "https://github.com/dotvav/py-palazzetti-api/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
