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
  version = "10.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    rev = "refs/tags/${version}";
    hash = "sha256-No0RDBgr40xSOiKXQRLRZnMdV+5i4eM8Jwp7c2Jw/ZY=";
  };

  patches = [
    (fetchpatch2 {
      name = "pymdown-extensions-pygments-compat.patch";
      url = "https://github.com/facelessuser/pymdown-extensions/commit/f1e2fad862c9738e420b8451dfdfbd9e90e849fc.patch";
      hash = "sha256-ENYTRXBJ76VPhhab8MdOh+bkcQNRklXT3thvPi+gHIY=";
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

  disabledTests = [
    # test artifact mismatch
    "test_toc_tokens"
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

  meta = with lib; {
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with licenses; [
      mit
      bsd2
    ];
    maintainers = with maintainers; [ cpcloud ];
  };
}
