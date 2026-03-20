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

buildPythonPackage rec {
  pname = "rich";
  version = "14.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "rich";
    tag = "v${version}";
    hash = "sha256-6udVO7N17ineQozlCG/tI9jJob811gqb4GtY50JZFb0=";
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
    changelog = "https://github.com/Textualize/rich/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ris ];
  };
}
