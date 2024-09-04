{
  lib,
  stdenv,
  fetchFromGitHub,
  python311Packages,
  go,
}:

python311Packages.buildPythonApplication rec {
  pname = "thefuck";
  version = "3.32";

  src = fetchFromGitHub {
    owner = "nvbn";
    repo = "thefuck";
    rev = "refs/tags/${version}";
    hash = "sha256-bRCy95owBJaxoyCNQF6gEENoxCkmorhyKzZgU1dQN6I=";
  };

  dependencies = with python311Packages; [
    colorama
    decorator
    psutil
    pyte
    six
  ];

  nativeCheckInputs =
    [ go ]
    ++ (with python311Packages; [
      mock
      pytest7CheckHook
      pytest-mock
    ]);

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_settings_defaults"
    "test_from_file"
    "test_from_env"
    "test_settings_from_args"
    "test_get_all_executables_exclude_paths"
    "test_with_blank_cache"
    "test_with_filled_cache"
    "test_when_etag_changed"
    "test_for_generic_shell"
    "test_on_first_run"
    "test_on_run_after_other_commands"
    "test_when_cant_configure_automatically"
    "test_when_already_configured"
    "test_when_successfully_configured"
  ];

  meta = {
    homepage = "https://github.com/nvbn/thefuck";
    description = "Magnificent app which corrects your previous console command";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcusramberg ];
  };
}
