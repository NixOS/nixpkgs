{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  markdown-it-py,
  pygments,
  typing-extensions,

  # optional-dependencies
  ipywidgets,

  # tests
  attrs,
  pytestCheckHook,
  setuptools,
  which,

  # for passthru.tests
  enrich,
  httpie,
  rich-rst,
  textual,
}:

buildPythonPackage rec {
  pname = "rich";
  version = "13.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-k+a64GDGzRDprvJz7s9Sm4z8jDV5TZ+CZLMgXKXXonM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    markdown-it-py
    pygments
  ] ++ lib.optionals (pythonOlder "3.9") [ typing-extensions ];

  optional-dependencies = {
    jupyter = [ ipywidgets ];
  };

  nativeCheckInputs = [
    attrs
    pytestCheckHook
    setuptools
    which
  ];

  disabledTests = [
    # pygments 2.16 compat
    # https://github.com/Textualize/rich/issues/3088
    "test_card_render"
    "test_markdown_render"
    "test_markdown_render"
    "test_python_render"
    "test_python_render_simple"
    "test_python_render_simple_passing_lexer_instance"
    "test_python_render_indent_guides"
    "test_option_no_wrap"
    "test_syntax_highlight_ranges"
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

  meta = with lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/Textualize/rich";
    changelog = "https://github.com/Textualize/rich/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
