{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  ruff,

  # dependencies
  cattrs,
  lsprotocol,
  python-lsp-server,

  # checks
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-lsp-ruff";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-ruff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1dgtuUX1GWKRiZOl5BYB/U8ecg42eTUMZqRYPKzHW/Y=";
  };

  postPatch =
    let
      ruffBin = lib.getExe ruff;
    in
    ''
      substituteInPlace pylsp_ruff/plugin.py \
        --replace-fail \
          "*find_executable(executable)" \
          '"${ruffBin}"'

      substituteInPlace tests/test_ruff_lint.py \
        --replace-fail "str(sys.executable)" '"${ruffBin}"' \
        --replace-fail '"-m",' "" \
        --replace-fail '"ruff",' "" \
        --replace-fail \
          'assert "ruff" in call_args' \
          'assert "${ruffBin}" in call_args' \
        --replace-fail \
          'ruff_executable = ruff_exe.name' \
          'ruff_executable = "${ruffBin}"' \
        --replace-fail 'os.chmod(ruff_executable, st.st_mode | stat.S_IEXEC)' ""
    ''
    # Nix builds everything in /build/ but ruff somehow doesn't run on files in /build/ and outputs empty results.
    + ''
      substituteInPlace tests/*.py \
        --replace-fail "workspace.root_path" '"/tmp/"'
    '';

  pythonRemoveDeps = [
    # ruff binary is used directly, the ruff python package is not needed
    "ruff"
  ];

  dependencies = [
    cattrs
    lsprotocol
    python-lsp-server
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/python-lsp/python-lsp-ruff";
    description = "Ruff linting plugin for pylsp";
    changelog = "https://github.com/python-lsp/python-lsp-ruff/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ linsui ];
  };
})
