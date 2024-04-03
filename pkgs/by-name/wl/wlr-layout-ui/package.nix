{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wlr-layout-ui";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdev31";
    repo = "wlr-layout-ui";
    rev = "${version}";
    hash = "sha256-YGETpbgY/KIw680H/4J6TZMaHNP5mNhEuDyYvD5BeIE=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyglet
    tomli
    tomli-w
  ];

  meta = with lib; {
    description = "A simple GUI to setup the screens layout on wlroots based systems.";
    homepage = "https://github.com/fdev31/wlr-layout-ui/";
    changelog = "https://github.com/fdev31/wlr-layout-ui/releases/tag/${src.rev}";
    maintainers = with maintainers; [ bnlrnz ];
    mainProgram = "wlr-layout-ui";
  };
}
