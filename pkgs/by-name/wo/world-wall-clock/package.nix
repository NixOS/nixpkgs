{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "world-wall-clock";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ddelabru";
    repo = "world-wall-clock";
    tag = "v${version}";
    hash = "sha256-OTBYSStCFBrZ8JutrhyyJpi7vRvBAUK0EKTtjvbi13I=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    tzdata
    urwid
    xdg-base-dirs
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/*" ];

  meta = {
    description = "TUI application that provides a multi-timezone graphical clock in a terminal environment.";
    homepage = "https://github.com/ddelabru/world-wall-clock";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ddelabru ];
    mainProgram = "wwclock";
    platforms = lib.platforms.all;
  };
}
