{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "word-search-generator";
  version = "3.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thelabcat";
    repo = "word-search-generator";
    rev = "v${version}";
    hash = "sha256-sImBEPJBXTA+l8+dRKOtPf8THm/sX7mp9J3fsIIYhYY=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    numpy
    pyside6
    tkinter
  ];

  meta = {
    description = "Create your own word search puzzles automatically from a list of words";
    homepage = "https://github.com/thelabcat/word-search-generator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chkno ];
    mainProgram = "wordsearchgen";
  };

  __structuredAttrs = true;
}
