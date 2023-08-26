{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, hatchling
, pytestCheckHook
, markdown
, pyyaml
, pygments

# for passthru.tests
, mkdocstrings
, mkdocs-material
, mkdocs-mermaid2-plugin
, hydrus
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
  version = "9.9.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    rev = "refs/tags/${version}";
    hash = "sha256-ld3NuBTjDJUN4ZK+eTwmmfzcB8XCtg8xaLMECo95+Cg=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-32309.part-1.patch";
      url = "https://github.com/facelessuser/pymdown-extensions/commit/b7bb4878d6017c03c8dc97c42d8d3bb6ee81db9d.patch";
      excludes = [
        "docs/src/markdown/about/changelog.md"
        "docs/src/markdown/extensions/snippets.md"
        "pymdownx/__meta__.py"
      ];
      hash = "sha256-JQRgtTfcy9Hrzj84dIxvz7Fpzv3JYKbil6B3BUPIkMw=";
    })
    (fetchpatch {
      name = "CVE-2023-32309.part-2.patch";
      url = "https://github.com/facelessuser/pymdown-extensions/commit/7c13bda5b7793b172efd1abb6712e156a83fe07d.patch";
      excludes = [
        "docs/src/markdown/about/changelog.md"
        "pymdownx/__meta__.py"
      ];
      hash = "sha256-3lVz2Ezw0fM2QVA6dfKllwpfDbEKl+YSoy2DHuUGIjY=";
    })
  ];

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ markdown pygments ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = map (ext: "pymdownx.${ext}") extensions;

  passthru.tests = {
    inherit mkdocstrings mkdocs-material mkdocs-mermaid2-plugin hydrus;
  };

  meta = with lib; {
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with licenses; [ mit bsd2 ];
    maintainers = with maintainers; [ cpcloud ];
  };
}
