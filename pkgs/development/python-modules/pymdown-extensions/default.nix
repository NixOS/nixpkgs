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
    "bracketspan"
    "caret"
    "critic"
    "details"
    "emoji"
    "escapeall"
    "extra"
    "fancylists"
    "highlight"
    "inlinehilite"
    "keys"
    "magiclink"
    "mark"
    "pathconverter"
    "progressbar"
    "quotes"
    "saneheaders"
    "slugs"
    "smartsymbols"
    "snippets"
    "striphtml"
    "superfences"
    "tabbed"
    "tasklist"
    "tilde"
  ];
in
buildPythonPackage (finalAttrs: {
  pname = "pymdown-extensions";
  version = "12.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    tag = finalAttrs.version;
    hash = "sha256-Qztx/Qh6+Pun+RzXMhzCTCptWRKj2GkMfEkJov+Qrdc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    markdown
    pygments
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
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
    changelog = "https://github.com/facelessuser/pymdown-extensions/blob/${finalAttrs.src.tag}/docs/src/markdown/about/changelog.md";
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with lib.licenses; [
      mit
      bsd2
    ];
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
