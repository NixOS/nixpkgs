{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  ply,
  prompt-toolkit,
  pygments,

  addBinToPathHook,
  writableTmpDirAsHomeHook,
  gitMinimal,
  glibcLocales,
  pip,
  pyte,
  pytest-mock,
  pytest-rerunfailures,
  pytest-subprocess,
  pytest-timeout,
  pytestCheckHook,
  requests,
  virtualenv,

  man,
  util-linux,

  coreutils,

  nix-update-script,
  python,
  callPackage,
}:

buildPythonPackage rec {
  pname = "xonsh";
  version = "0.23.0";
  pyproject = true;

  # PyPI package ships incomplete tests
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xonsh";
    tag = version;
    hash = "sha256-hZMA1GMyzo2297iTrgOdRuqjqR55KughPsaL0EZWLWM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ply
    prompt-toolkit
    pygments
  ];

  nativeCheckInputs = [
    addBinToPathHook
    writableTmpDirAsHomeHook
    gitMinimal
    glibcLocales
    pip
    pyte
    pytest-mock
    pytest-rerunfailures
    pytest-subprocess
    pytest-timeout
    pytestCheckHook
    requests

    # required by test_xonsh_activator
    virtualenv
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    # required by test_man_completion
    man
    util-linux
  ];

  disabledTests = [
    # fails on sandbox
    "test_colorize_file"
    "test_repath_HOME_PATH_itself"
    "test_repath_HOME_PATH_var"
    "test_repath_HOME_PATH_var_brace"

    # flaky tests in test_integrations.py
    "test_script"
    "test_catching_system_exit"
    "test_catching_exit_signal"
    "test_captured_subproc_is_not_affected_next_command"
    "test_spec_decorator_alias"

    # flaky tests in test_python.py
    "test_complete_import"

    # flaky tests in test_pipelines.py
    "test_command_pipeline_capture"
    "test_remove_hide_escape"

    # flaky tests in test_specs.py
    "test_capture_always"
    "test_callias_captured_redirect"
    "test_interrupted_process_returncode"
    "test_proc_raise_subproc_error"
    "test_specs_with_suspended_captured_process_pipeline"
    "test_subproc_output_format"

    # flaky tests in test_vc.py
    "test_vc_get_branch"
    "test_dirty_working_directory"
  ]
  ++ lib.optionals stdenv.isDarwin [
    # fails on Darwin
    "test_bash_and_is_alias_is_only_functional_alias"
    "test_complete_command"
    "test_man_completion"
    "test_on_command_not_found_replacement"
    "test_skipper_command"
    "test_xonsh_lexer_no_win"
    "test_on_command_not_found_dict_without_env"
  ];

  disabledTestPaths = [
    # don't run stress tests when building package
    "tests/xintegration/test_stress.py"
  ];

  # https://github.com/NixOS/nixpkgs/issues/248978
  dontWrapPythonPrograms = true;

  postPatch = ''
    sed -i -e 's|/bin/ls|${lib.getExe' coreutils "ls"}|' tests/test_execer.py
    sed -i -e 's|SHELL=xonsh|SHELL=$out/bin/xonsh|' tests/xintegration/test_integrations.py

    for script in tests/xintegration/test_integrations.py scripts/xon.sh $(find -name "*.xsh"); do
      sed -i -e 's|/usr/bin/env|${lib.getExe' coreutils "env"}|' $script
    done
    patchShebangs .
  '';

  passthru = {
    inherit python;
    shellPath = "/bin/xonsh";
    wrapper = throw "The top-level xonsh package is now wrapped. Use it directly.";
    updateScript = nix-update-script { };
    xontribs = import ./xontribs { inherit callPackage; };
  };

  meta = {
    homepage = "https://xon.sh/";
    description = "Python-powered shell";
    changelog = "https://github.com/xonsh/xonsh/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ bsd3 ];
    mainProgram = "xonsh";
    maintainers = with lib.maintainers; [ samlukeyes123 ];
  };
}
