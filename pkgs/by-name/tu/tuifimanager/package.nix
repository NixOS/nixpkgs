{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tuifimanager";
  version = "4.0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "GiorgosXou";
    repo = "TUIFIManager";
    rev = "refs/tags/v${version}";
    hash = "sha256-DuCrIJuADmJ0MHIP0+OJ0zCrQR/oGdgzJ1xck4m/tPo=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
  ];

  propagatedBuildInputs = [
    python3.pkgs.send2trash
    python3.pkgs.unicurses
  ];
  pythonImportsCheck = [ "TUIFIManager" ];

  meta = with lib; {
    description = "A cross-platform terminal-based termux-oriented file manager";
    longDescription = ''
      A cross-platform terminal-based termux-oriented file manager (and component),
      meant to be used with a Uni-Curses project or as is. This project is mainly an
      attempt to get more attention to the Uni-Curses project.
    '';
    homepage = "https://github.com/GiorgosXou/TUIFIManager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michaelBelsanti sigmanificient ];
    mainProgram = "tuifi";
  };
}
