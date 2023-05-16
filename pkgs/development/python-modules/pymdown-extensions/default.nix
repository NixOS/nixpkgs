{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pytestCheckHook
, markdown
, pyyaml
, pygments
<<<<<<< HEAD

# for passthru.tests
, mkdocstrings
, mkdocs-material
, mkdocs-mermaid2-plugin
, hydrus
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  version = "10.1.0";
=======
  version = "9.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-KqDEmWAWXdDpQPsP9Vrced+Ozz9IZiD8rCG57hPR7Xs=";
=======
    hash = "sha256-ld3NuBTjDJUN4ZK+eTwmmfzcB8XCtg8xaLMECo95+Cg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ markdown pygments ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = map (ext: "pymdownx.${ext}") extensions;

<<<<<<< HEAD
  passthru.tests = {
    inherit mkdocstrings mkdocs-material mkdocs-mermaid2-plugin hydrus;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with licenses; [ mit bsd2 ];
    maintainers = with maintainers; [ cpcloud ];
  };
}
