{
  lib,
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
  pytest-subprocess,
  pytestCheckHook,
  requests,

  man,
  util-linux,

  coreutils,

  nix-update-script,
  python,
  callPackage,
}:

buildPythonPackage rec {
  pname = "xonsh";
  version = "0.22.8";
  pyproject = true;

  # PyPI package ships incomplete tests
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xonsh";
    tag = version;
    hash = "sha256-NOQs21Ahp2oMx1Lw1ekvb2aqUWwIXw1WyC9ZE5V9wJI=";
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
    pytest-subprocess
    pytestCheckHook
    requests

    # required by test_man_completion
    man
    util-linux
  ];

  disabledTests = [
    # fails on sandbox
    "test_colorize_file"
    "test_xonsh_activator"

    # flaky tests in test_integrations.py
    "test_script"
    "test_catching_system_exit"
    "test_catching_exit_signal"
    "test_alias_stability"
    "test_captured_subproc_is_not_affected_next_command"
    "test_spec_decorator_alias"
    "test_alias_stability_exception"

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
  ];

  # https://github.com/NixOS/nixpkgs/issues/248978
  dontWrapPythonPrograms = true;

  env.LC_ALL = "en_US.UTF-8";

  postPatch = ''
    sed -i -e 's|/bin/ls|${lib.getExe' coreutils "ls"}|' tests/test_execer.py
    sed -i -e 's|SHELL=xonsh|SHELL=$out/bin/xonsh|' tests/test_integrations.py

    for script in tests/test_integrations.py scripts/xon.sh $(find -name "*.xsh"); do
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
    description = "Python-ish, BASHwards-compatible shell";
    changelog = "https://github.com/xonsh/xonsh/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ bsd3 ];
    mainProgram = "xonsh";
    maintainers = with lib.maintainers; [ samlukeyes123 ];
  };
}
