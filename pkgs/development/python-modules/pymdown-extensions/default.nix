{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "9.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    rev = version;
    sha256 = "sha256-II8Po8144h3wPFrzMbOB/qiCm2HseYrcZkyIZFGT+ek=";
  };

  patches = [
    # this patch is needed to allow tests to pass for later versions of the
    # markdown dependency
    #
    # it can be removed after the next pymdown-extensions release
    (fetchpatch {
      url = "https://github.com/facelessuser/pymdown-extensions/commit/8ee5b5caec8f9373e025f50064585fb9d9b71f86.patch";
      sha256 = "sha256-jTHNcsV0zL0EkSTSj8zCGXXtpUaLnNPldmL+krZj3Gk=";
    })
  ];

  propagatedBuildInputs = [ markdown pygments ];

  checkInputs = [
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
