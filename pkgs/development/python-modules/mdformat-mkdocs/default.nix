{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  mdformat-beautysh,
  mdformat-footnote,
  mdformat-front-matters,
  mdformat-gfm,
  mdformat-simple-breaks,
  mdformat,
  mdit-py-plugins,
  more-itertools,
  pytest-snapshot,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdformat-mkdocs";
  version = "5.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-mkdocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PklT9LlaIQFG194zhHQhzR8kVe084Q+1Bo9180eOMd0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.10" "uv_build"
  '';

  build-system = [
    uv-build
  ];

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
      mdformat-front-matters
      # mdformat-ruff
      mdformat-simple-breaks
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
    changelog = "https://github.com/KyleKing/mdformat-mkdocs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
})
