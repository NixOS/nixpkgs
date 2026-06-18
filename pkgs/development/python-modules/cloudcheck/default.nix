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
  starlette,
  tornado,
}:

buildPythonPackage rec {
  pname = "cloudcheck";
  version = "9.3.0";
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
    starlette
    tornado
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
