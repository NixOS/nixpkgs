{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat-beautysh,
  mdformat-footnote,
  mdformat-frontmatter,
  mdformat-gfm,
  mdformat-simple-breaks,
  mdformat-tables,
  mdformat,
  mdit-py-plugins,
  more-itertools,
  pytest-snapshot,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdformat-mkdocs";
  version = "5.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-mkdocs";
    tag = "v${version}";
    hash = "sha256-PklT9LlaIQFG194zhHQhzR8kVe084Q+1Bo9180eOMd0=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    mdformat-gfm
    mdit-py-plugins
    more-itertools
  ];

  optional-dependencies = {
    recommended = [
      mdformat-beautysh
      # mdformat-config
      mdformat-footnote
      mdformat-frontmatter
      # mdformat-ruff
      mdformat-simple-breaks
      mdformat-tables
      # mdformat-web
      # mdformat-wikilink
    ];
  };

  nativeCheckInputs = [
    pytest-snapshot
    pytestCheckHook
  ];

  disabledTestPaths = [
    # AssertionError: assert ParsedText(lines=[LineResult(parsed=ParsedLine(line_...
    "tests/format/test_parsed_result.py"
  ];

  pythonImportsCheck = [ "mdformat_mkdocs" ];

  meta = {
    description = "Mdformat plugin for MkDocs";
    homepage = "https://github.com/KyleKing/mdformat-mkdocs";
    changelog = "https://github.com/KyleKing/mdformat-mkdocs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
}
