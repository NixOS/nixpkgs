{
  lib,
  authlib,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
  websockets,
}:

buildPythonPackage rec {
  pname = "lmcloud";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "pylamarzocco";
    rev = "refs/tags/v.${version}";
    hash = "sha256-uYd52T9dAvFP6in1fHiCXFVUdbRXDE7crjfelbasW4Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    authlib
    bleak
    httpx
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "lmcloud" ];

  meta = with lib; {
    description = "Library to interface with La Marzocco's cloud";
    homepage = "https://github.com/zweckj/pylamarzocco";
    changelog = "https://github.com/zweckj/pylamarzocco/releases/tag/v.${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
