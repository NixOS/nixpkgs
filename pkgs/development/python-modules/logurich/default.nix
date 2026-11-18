{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  loguru,
  pytestCheckHook,
  rich,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "logurich";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PakitoSec";
    repo = "logurich";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WkbE1bUWQWd/Zb9Nkv0HMNp9FK6QRceWmdm0zplD9HU=";
  };

  pythonRelaxBuildSystem = [ "uv_build" ];

  pythonRelaxDeps = [ "rich" ];

  build-system = [ uv-build ];

  dependencies = [
    loguru
    rich
  ];

  optional-dependencies = {
    click = [ click ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "logurich" ];

  meta = {
    description = "Logger that combine loguru and rich";
    homepage = "https://github.com/PakitoSec/logurich";
    changelog = "https://github.com/PakitoSec/logurich/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
