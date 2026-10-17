{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pygments,
  pytestCheckHook,
  rich,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "rich-rst";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wasi-master";
    repo = "rich-rst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T90U1KC6gg0145t+mGOJhDKFeQmcAczXcRBPQnDQXqs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pygments
    rich
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rich_rst" ];

  meta = {
    description = "Beautiful reStructuredText renderer for rich";
    homepage = "https://github.com/wasi-master/rich-rst";
    changelog = "https://github.com/wasi-master/rich-rst/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
