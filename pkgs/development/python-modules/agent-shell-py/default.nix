{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
  coreutils,
  procps,
  runCommand,

  # build-system
  hatch-vcs,
  hatchling,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  tmux,
  util-linux,
}:

buildPythonPackage (finalAttrs: {
  pname = "agent-shell-py";
  version = "0.5.1";
  pyproject = true;

  # Upstream declares requires-python >=3.12, and nixpkgs does not enforce that
  # metadata, so without this the attribute exists for 3.11 and a build is
  # attempted there.
  disabled = pythonOlder "3.12";

  src = fetchPypi {
    pname = "agent_shell_py";
    inherit (finalAttrs) version;
    hash = "sha256-CMWiTCInGCtwHJwHKz7SQWSqyfaYmmDdbxEGKn3H9ew=";
  };

  # The sdist carries no .git and hatch-vcs resolves the version from git
  # metadata, so the build hook has to be told which version this is.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = [
    hatch-vcs
    hatchling
  ];

  # No runtime dependencies, which upstream asserts with a dedicated check.
  dependencies = [ ];

  # The PID-namespace tests skip unless `unshare` and `pkill` are on PATH, which
  # the build sandbox does not provide. Adding them makes those tests run.
  # coreutils supplies `true`, which the immediate-exit test looks up on PATH.
  nativeCheckInputs = [
    coreutils
    procps
    pytest-asyncio
    pytestCheckHook
    tmux
    util-linux
  ];

  disabledTestPaths = [
    # Drives real CLI agents, needs credentials, and is excluded upstream too.
    "tests/e2e"
    # Architecture contracts: these shell out to `lint-imports` and assert the
    # repository's own module layering against the source tree. import-linter
    # and its grimp dependency are not packaged in nixpkgs.
    "tests/integration/test_architecture.py"
    # Spawns `python -m agent_shell.terminal_worker` with a filtered environment
    # (desktop variables only), so the worker can only import this package from
    # the interpreter's own site-packages. Covered by passthru.tests instead.
    "tests/integration/test_terminal_window_execution_host.py"
  ];

  # The interactive-terminal tests spawn tmux, which wants a writable HOME.
  preCheck = ''
    export HOME="$TMPDIR"
  '';

  pythonImportsCheck = [ "agent_shell" ];

  passthru.tests.terminal-window =
    runCommand "agent-shell-py-terminal-window-tests"
      {
        nativeBuildInputs = [
          (python.withPackages (ps: [
            finalAttrs.finalPackage
            ps.pytest
            ps.pytest-asyncio
          ]))
          tmux
        ];
      }
      ''
        export HOME="$TMPDIR"
        tar xzf ${finalAttrs.src}
        cd agent_shell_py-${finalAttrs.version}

        pytest tests/integration/test_terminal_window_execution_host.py -m "not e2e" -q
        touch $out
      '';

  meta = {
    description = "Lightweight abstraction for executing CLI coding agents headlessly";
    homepage = "https://github.com/scottrbk/agent-shell";
    changelog = "https://github.com/scottrbk/agent-shell/releases/tag/v${finalAttrs.version}";
    # The library imports fcntl at module level and uses asyncio unix sockets, so
    # it needs a POSIX platform. Only x86_64-linux has been built.
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twstagg ];
  };
})
