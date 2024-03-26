{ lib
, coreutils
, fetchFromGitHub
, git
, gitUpdater
, glibcLocales
, python3
}:

let
  pname = "xonsh";
  version = "0.15.1";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;

  pyproject = true;

  # fetch from github because the pypi package ships incomplete tests
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xonsh";
    rev = "refs/tags/${version}";
    hash = "sha256-mHOCkUGiSSPmkIQ4tgRZIaCTLgnx39SMwug5EIx/jrU=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ply
    prompt-toolkit
    pygments
  ];

  env.LC_ALL = "en_US.UTF-8";

  postPatch = ''
    sed -ie "s|/bin/ls|${coreutils}/bin/ls|" tests/test_execer.py
    sed -ie "s|SHELL=xonsh|SHELL=$out/bin/xonsh|" tests/test_integrations.py

    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' tests/test_integrations.py
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' scripts/xon.sh
    find scripts -name 'xonsh*' -exec sed -i -e "s|env -S|env|" {} \;
    find -name "*.xsh" | xargs sed -ie 's|/usr/bin/env|${coreutils}/bin/env|'
    patchShebangs .
  '';

  disabledTests = [
    # fails on sandbox
    "test_colorize_file"
    "test_loading_correctly"
    "test_no_command_path_completion"
    "test_bsd_man_page_completions"
    "test_xonsh_activator"
    # fails on non-interactive shells
    "test_capture_always"
    "test_casting"
    "test_command_pipeline_capture"
    "test_dirty_working_directory"
    "test_man_completion"
    "test_vc_get_branch"
    "test_bash_and_is_alias_is_only_functional_alias"
  ];

  disabledTestPaths = [
    # fails on sandbox
    "tests/completers/test_command_completers.py"
    "tests/test_ptk_highlight.py"
    "tests/test_ptk_shell.py"
    # fails on non-interactive shells
    "tests/prompt/test_gitstatus.py"
    "tests/completers/test_bash_completer.py"
  ];

  nativeCheckInputs = [
    git
    glibcLocales
  ] ++ (with python3.pkgs; [
    pip
    pyte
    pytest-mock
    pytest-subprocess
    pytestCheckHook
  ]);

  preCheck = ''
    export HOME=$TMPDIR
  '';

  dontWrapPythonPrograms = true;

  passthru = {
    shellPath = "/bin/xonsh";
    python = python3; # To the wrapper
    updateScript = gitUpdater { };
  };

  meta =  {
    homepage = "https://xon.sh/";
    description = "A Python-ish, BASHwards-compatible shell";
    changelog = "https://github.com/xonsh/xonsh/raw/${version}/CHANGELOG.rst";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
