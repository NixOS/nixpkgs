{ lib
, pkgs
, buildPythonPackage
, fetchFromGitHub
, pygame
, python-i18n
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygame-gui";
  version = "069";
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "MyreMylar";
    repo = "pygame_gui";
    rev = "refs/tags/v_${version}";
    hash = "sha256-IXU00Us1odbfS7jLPMYuCPv2l/5TUZdYKES7xHs+EWg=";
  };

  propagatedBuildInputs = [ pygame python-i18n ];

  postPatch = ''
    substituteInPlace pygame_gui/core/utility.py \
      --replace "xsel" "${pkgs.xsel}/bin/xsel"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

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

  disabledTestPaths = [
    "tests/test_performance/test_text_performance.py"
  ];

  meta = with lib; {
    description = "A GUI system for pygame";
    homepage = "https://github.com/MyreMylar/pygame_gui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ emilytrau ];
  };
}
