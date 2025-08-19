{
  lib,
  pkgs,
  stdenv,
  buildPythonPackage,
  nix-update-script,
  fetchFromGitHub,
  setuptools,
  pygame-ce,
  python-i18n,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygame-gui";
  version = "0614";
  pyproject = true;
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "MyreMylar";
    repo = "pygame_gui";
    tag = "v_${version}";
    hash = "sha256-wLvWaJuXMXk7zOaSZfIpsXhQt+eCjOtlh8IRuKbR75o=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pygame-ce
    python-i18n
  ];

  postPatch = ''
    substituteInPlace pygame_gui/core/utility.py \
      --replace-fail "xsel" "${lib.getExe pkgs.xsel}"
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

  meta = with lib; {
    description = "GUI system for pygame";
    homepage = "https://github.com/MyreMylar/pygame_gui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      emilytrau
      pbsds
    ];
  };
}
