{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  poetry-core,
  poetry-dynamic-versioning,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  radixtarget,
  regex,
}:

buildPythonPackage rec {
  pname = "cloudcheck";
  version = "7.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "cloudcheck";
    tag = "v${version}";
    hash = "sha256-z2KJ6EaqQLc2oQBZCfKMejPlTdgYGzmDPm/rGLHXCQA=";
  };

  pythonRelaxDeps = [
    "radixtarget"
    "regex"
  ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    httpx
    pydantic
    radixtarget
    regex
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cloudcheck" ];

  meta = {
    description = "Module to check whether an IP address or hostname belongs to popular cloud providers";
    homepage = "https://github.com/blacklanternsecurity/cloudcheck";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
