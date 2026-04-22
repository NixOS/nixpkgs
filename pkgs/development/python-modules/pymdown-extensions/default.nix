{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  markdown,
  pyyaml,
  pygments,

  # for passthru.tests
  mkdocstrings,
  mkdocs-material,
  mkdocs-mermaid2-plugin,
  hydrus,
}:

let
  extensions = [
    "arithmatex"
    "b64"
    "betterem"
    "caret"
    "critic"
    "details"
    "emoji"
    "escapeall"
    "extra"
    "highlight"
    "inlinehilite"
    "keys"
    "magiclink"
    "mark"
    "pathconverter"
    "progressbar"
    "saneheaders"
    "smartsymbols"
    "snippets"
    "striphtml"
    "superfences"
    "tabbed"
    "tasklist"
    "tilde"
  ];
in
buildPythonPackage rec {
  pname = "pymdown-extensions";
  version = "10.21.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    tag = version;
    hash = "sha256-BKnrq8m+xQYZs6V+x+3al7yS8531UvvaC4V+ny+f+Qg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    markdown
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = map (ext: "pymdownx.${ext}") extensions;

  passthru.tests = {
    inherit
      mkdocstrings
      mkdocs-material
      mkdocs-mermaid2-plugin
      hydrus
      ;
  };

  meta = {
    changelog = "https://github.com/facelessuser/pymdown-extensions/blob/${src.tag}/docs/src/markdown/about/changelog.md";
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with lib.licenses; [
      mit
      bsd2
    ];
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
