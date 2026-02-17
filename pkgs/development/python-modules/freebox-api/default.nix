{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "freebox-api";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "freebox-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3rmOIHneGUtaLw+0Z0UTKoCSoJs70KKLjDPi0gOtV6I=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "urllib3" ];

  dependencies = [
    aiohttp
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "freebox_api" ];

  meta = {
    description = "Python module to interact with the Freebox OS API";
    homepage = "https://github.com/hacf-fr/freebox-api";
    changelog = "https://github.com/hacf-fr/freebox-api/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "freebox_api";
  };
})
