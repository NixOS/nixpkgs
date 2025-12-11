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

  coreutils,

  nix-update-script,
  python,
  callPackage,
}:

buildPythonPackage rec {
  pname = "xonsh";
  version = "0.20.0";
  pyproject = true;

  # PyPI package ships incomplete tests
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xonsh";
    tag = version;
    hash = "sha256-Wd75BMJUi8JfiBM1gekylR4+qJOQm3k3vqJILOr0xnE=";
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
  ];

  disabledTests = [
    # fails on sandbox
    "test_bsd_man_page_completions"
    "test_colorize_file"
    "test_loading_correctly"
    "test_no_command_path_completion"
    "test_xonsh_activator"

    # fails on non-interactive shells
    "test_bash_and_is_alias_is_only_functional_alias"
    "test_capture_always"
    "test_casting"
    "test_command_pipeline_capture"
    "test_dirty_working_directory"
    "test_man_completion"
    "test_vc_get_branch"

    # flaky tests
    "test_alias_stability"
    "test_alias_stability_exception"
    "test_complete_import"
    "test_script"
    "test_subproc_output_format"

    # broken tests
    "test_repath_backslash"

    # https://github.com/xonsh/xonsh/issues/5569
    "test_spec_decorator_alias_output_format"
    "test_trace_in_script"
  ];

  disabledTestPaths = [
    # fails on sandbox
    "tests/completers/test_command_completers.py"
    "tests/shell/test_ptk_highlight.py"

    # fails on non-interactive shells
    "tests/prompt/test_gitstatus.py"
    "tests/completers/test_bash_completer.py"
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
    changelog = "https://github.com/xonsh/xonsh/raw/main/CHANGELOG.rst";
    license = with lib.licenses; [ bsd3 ];
    mainProgram = "xonsh";
    maintainers = with lib.maintainers; [ samlukeyes123 ];
  };
}
