{ lib
, substituteAll
, buildPythonPackage
, fetchFromGitHub
, pygame
, pytestCheckHook
, pkgs
}:

buildPythonPackage rec {
  pname = "pygame-gui";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "MyreMylar";
    repo = "pygame_gui";
    rev = "v_057";
    sha256 = "4P2PT8/7oA5Q7H4+pm7BOET7w05pQYQltXVV3+YVrVE=";
  };

  propagatedBuildInputs = [ pygame ];

  patches = [
    # Fix path to xsel binary
    (substituteAll {
      src = ./fix-paths.patch;
      xsel = "${pkgs.xsel}/bin/xsel";
    })
    # Clipboard doesn't exist in test environment. Let's skip it
    ./skip-clipboard-tests.patch
  ];

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    export HOME=$TMPDIR
    export SDL_VIDEODRIVER=dummy
  '';

  meta = with lib; {
    description = "A GUI system for pygame";
    homepage = "https://github.com/MyreMylar/pygame_gui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ angustrau ];
  };
}
