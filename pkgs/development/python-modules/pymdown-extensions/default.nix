{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "10.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    rev = "refs/tags/${version}";
    hash = "sha256-KqDEmWAWXdDpQPsP9Vrced+Ozz9IZiD8rCG57hPR7Xs=";
  };

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
