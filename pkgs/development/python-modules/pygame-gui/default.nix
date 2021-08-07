{ lib
, pkgs
, buildPythonPackage
, fetchFromGitHub
, pygame
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygame-gui";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "MyreMylar";
    repo = "pygame_gui";
    rev = "v_${lib.replaceStrings ["."] [""] version}";
    sha256 = "4P2PT8/7oA5Q7H4+pm7BOET7w05pQYQltXVV3+YVrVE=";
  };

  propagatedBuildInputs = [ pygame ];

  postPatch = ''
    substituteInPlace pygame_gui/core/utility.py \
      --replace "xsel" "${pkgs.xsel}/bin/xsel"
  '';

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
    export SDL_VIDEODRIVER=dummy
  '';

  disabledTests = [
    # Clipboard doesn't exist in test environment
    "test_process_event_text_ctrl_c"
    "test_process_event_text_ctrl_v"
    "test_process_event_text_ctrl_v_nothing"
    "test_process_event_ctrl_v_over_limit"
    "test_process_event_ctrl_v_at_limit"
    "test_process_event_ctrl_v_over_limit_select_range"
    "test_process_event_text_ctrl_v_select_range"
    "test_process_event_text_ctrl_a"
    "test_process_event_text_ctrl_x"
  ];

  meta = with lib; {
    description = "A GUI system for pygame";
    homepage = "https://github.com/MyreMylar/pygame_gui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ angustrau ];
  };
}
