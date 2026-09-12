{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  beartype,
  rich,
  typing-extensions,

  # tests
  ipython,
  numpy,
  pytestCheckHook,
  sybil,
}:

buildPythonPackage (finalAttrs: {
  pname = "plum-dispatch";
  version = "2.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beartype";
    repo = "plum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oQTM2Op/ymNYu0yCOADI9Is2RutwF+AYmhMLAkMe87s=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    beartype
    rich
    typing-extensions
  ];

  pythonImportsCheck = [ "plum" ];

  nativeCheckInputs = [
    ipython
    numpy
    pytestCheckHook
    sybil
  ];

  meta = {
    description = "Multiple dispatch in Python";
    homepage = "https://github.com/beartype/plum";
    changelog = "https://github.com/beartype/plum/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
