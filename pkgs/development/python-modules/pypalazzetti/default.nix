{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pypalazzetti";
  version = "0.1.16";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dotvav";
    repo = "py-palazzetti-api";
    tag = "v${version}";
    hash = "sha256-JYTrZ1Ty9y+yvoeVXus1qqNFnB0NmczCz6Kq2PjpiLk=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
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
