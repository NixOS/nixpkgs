{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "10.21.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    tag = version;
    hash = "sha256-hu9fXjZxlris3AhPS7bz3kcSyQtSeh0B6ZAZBsCO4+g=";
  };

  patches = [
    # Remove when updating to 11.0.0 or later.
    (fetchpatch2 {
      name = "CVE-2026-61632.patch";
      url = "https://github.com/facelessuser/pymdown-extensions/commit/edce35586d11a1ef78bb187bc60497fe6dbf3b64.patch?full_index=1";
      hash = "sha256-0J/ruQG73Lku/z+lFnb8XWT5WK+psiJyHq3/3ezUY8k=";
    })
    # Remove when updating to 11.0.1 or later.
    (fetchpatch2 {
      name = "CVE-2026-67422.patch";
      url = "https://github.com/facelessuser/pymdown-extensions/commit/c68498598d7b13011bb4571350b6e3612a4ce44b.patch?full_index=1";
      excludes = [
        "docs/src/markdown/about/changelog.md"
        "pymdownx/__meta__.py"
      ];
      hash = "sha256-r69jhMjTR/1oeSLifjZzG+wXYceSlkUk0KIPsGkOi1E=";
    })
  ];

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
