{
  lib,
  python3Packages,
  fetchFromGitHub,
  bibtool,
}:

python3Packages.buildPythonApplication {
  pname = "termpdf.py";
  version = "2022-03-28";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dsanson";
    repo = "termpdf.py";
    rev = "e7bd0824cb7d340b8dba7d862e696dba9cb5e5e2";
    sha256 = "HLQZBaDoZFVBs4JfJcwhrLx8pxdEI56/iTpUjT5pBhk=";
  };

  propagatedBuildInputs = [
    bibtool
    python3Packages.pybtex
    python3Packages.pymupdf
    python3Packages.pyperclip
    python3Packages.roman
    python3Packages.pagelabels
    python3Packages.pdfrw
    python3Packages.pynvim
    python3Packages.setuptools
  ];

  # upstream doesn't contain tests
  doCheck = false;

  meta = {
    description = ''
      A graphical pdf (and epub, cbz, ...) reader that works
      inside the kitty terminal.
    '';
    mainProgram = "termpdf.py";
    homepage = "https://github.com/dsanson/termpdf.py";
    maintainers = with lib.maintainers; [ teto ];
    license = lib.licenses.mit;
  };
}
