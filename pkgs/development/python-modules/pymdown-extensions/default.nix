{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pytestCheckHook
, markdown
, pyyaml
, pygments
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

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ markdown pygments ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = map (ext: "pymdownx.${ext}") extensions;

  meta = with lib; {
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with licenses; [ mit bsd2 ];
    maintainers = with maintainers; [ cpcloud ];
  };
}
