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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-mkdocs";
  version = "4.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-mkdocs";
    tag = "v${version}";
    hash = "sha256-J1gLi85tEFJcWupV2FzunJhROFdU3G12hRHxbLSX0kc=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Mdformat plugin for MkDocs";
    homepage = "https://github.com/KyleKing/mdformat-mkdocs";
    changelog = "https://github.com/KyleKing/mdformat-mkdocs/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
