{
  python3,
  fetchFromGitHub,
  lib,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "textlsp";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hangyav";
    repo = "textLSP";
    tag = "v${finalAttrs.version}";
    hash = "sha256-euzihVBwpCgLD74SDOPD5P3X3vhEIBd4pP5EyVhPccQ=";
  };

  build-system = [ python3.pkgs.setuptools ];
  dependencies = with python3.pkgs; [
    pygls
    lsprotocol
    language-tool-python
    tree-sitter
    gitpython
    appdirs
    openai
    sortedcontainers
    langdetect
    ollama
  ];

  meta = {
    description = "Language server for text spell and grammar check with various tools";
    homepage = "https://github.com/hangyav/textLSP/tree/main";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ justdeeevin ];
    mainProgram = "textlsp";
    changelog = "https://github.com/hangyav/textLSP/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.all;
  };
})
