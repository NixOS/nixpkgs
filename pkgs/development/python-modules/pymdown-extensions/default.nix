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
<<<<<<< HEAD
  version = "10.17.2";
=======
  version = "10.16.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-eE7DgMdUqSzjeDU7hZ7FCZC8Oyj2YpPtjAQbaLPKOhk=";
=======
    hash = "sha256-My1sTzWXInXb4TJ3uB7IXRyUrlbJMxrWyzzge8O0ZmQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  disabledTests = [
    # test artifact mismatch
    "test_toc_tokens"
    # Tests fails with AssertionError
    "test_windows_root_conversion"
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

<<<<<<< HEAD
  meta = {
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with lib.licenses; [
      mit
      bsd2
    ];
    maintainers = with lib.maintainers; [ cpcloud ];
=======
  meta = with lib; {
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with licenses; [
      mit
      bsd2
    ];
    maintainers = with maintainers; [ cpcloud ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
