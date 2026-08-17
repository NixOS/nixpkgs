{
  lib,
  pkgs,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pygame-ce,
  python-i18n,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygame-gui";
  version = "0614";
  pyproject = true;
  __structuredAttrs = true;
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "MyreMylar";
    repo = "pygame_gui";
    tag = "v_${finalAttrs.version}";
    hash = "sha256-wLvWaJuXMXk7zOaSZfIpsXhQt+eCjOtlh8IRuKbR75o=";
  };

  postPatch = ''
    substituteInPlace pygame_gui/core/utility.py \
      --replace-fail "xsel" "${lib.getExe pkgs.xsel}"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    pygame-ce
    python-i18n
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
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

    # Pixel-level rendering mismatches with pygame-ce 2.5.7
    "test_clear"
    "test_creation_grow_to_fit_width"
    "test_draw_ui"
    "test_on_hovered"
    "test_on_unhovered"
    "test_process_event_mouse_buttons"
    "test_set_active"
    "test_set_cursor_from_click_pos"
    "test_set_cursor_position"
    "test_set_default_text_colour"
    "test_set_inactive"
    "test_set_text"
    "test_split"
    "test_split_index"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fails to determine "/" as an existing path
    # https://github.com/MyreMylar/pygame_gui/issues/644
    "test_process_event"
  ];

  disabledTestPaths = [ "tests/test_performance/test_text_performance.py" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v_(.*)"
    ];
  };

  meta = {
    description = "GUI system for pygame";
    homepage = "https://github.com/MyreMylar/pygame_gui";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      emilytrau
      pbsds
    ];
  };
})
