{
  python3,
  fetchFromGitHub,
  lib,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "textlsp";
  version = "0.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hangyav";
    repo = "textLSP";
    tag = "v${version}";
    hash = "sha256-Z1ozkS6zo/h0j0AU5K+Ri/ml8KqCjdEcQKpFtNER4Hk=";
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
    changelog = "https://github.com/hangyav/textLSP/releases/tag/v${version}";
    platforms = lib.platforms.all;
  };
}
