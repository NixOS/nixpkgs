{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  markdown-it-py,
  pygments,

  # optional-dependencies
  ipywidgets,

  # tests
  attrs,
  pytestCheckHook,
  which,

  # for passthru.tests
  enrich,
  httpie,
  rich-rst,
  textual,
}:

buildPythonPackage (finalAttrs: {
  pname = "rich";
  version = "15.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "rich";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uk3r6aYhrjYJ8GrMKfdlv3/muK/uUynd4pd1yWCwSOM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    pygments
  ];

  optional-dependencies = {
    jupyter = [ ipywidgets ];
  };

  nativeCheckInputs = [
    attrs
    pytestCheckHook
    which
  ];

  pythonImportsCheck = [ "rich" ];

  passthru.tests = {
    inherit
      enrich
      httpie
      rich-rst
      textual
      ;
  };

  meta = {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/Textualize/rich";
    changelog = "https://github.com/Textualize/rich/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ris ];
  };
})
