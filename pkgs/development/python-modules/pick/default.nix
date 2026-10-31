{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pick";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aisk";
    repo = "pick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/cvnDTRS3V9mk1T0zHAqdrDeRuOrnco9UF7luy687BM=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pick" ];

  meta = {
    description = "Module to create curses-based interactive selection list in the terminal";
    homepage = "https://github.com/aisk/pick";
    changelog = "https://github.com/aisk/pick/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      aisk
    ];
  };
})
