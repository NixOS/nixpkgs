{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  nix-update-script,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "tokentopper";
  version = "0.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kalmantic";
    repo = "tokentopper";
    tag = "tokentopper-v${finalAttrs.version}";
    hash = "sha256-e6qlGlQ6Nmlxp7ZZFsz2VoVmPOfsKuuFnX8eBS9RpQ8=";
  };

  npmDepsHash = "sha256-iv3S/g0Fwwl2d9tlYAcmqI7SUVIBIrJtUaecb+uEdeI=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };

    tests.smoke = runCommand "tokentopper-smoke-test" {
      nativeBuildInputs = [
        finalAttrs.finalPackage
        jq
      ];
    } ''
      export HOME="$(mktemp -d)"
      mkdir -p "$HOME/.claude/projects/nix-smoke"
      printf '%s\n' '{"type":"assistant","timestamp":"2026-07-01T10:00:00.000Z","sessionId":"nix-smoke","message":{"id":"nix-smoke-message","model":"claude-sonnet-4","usage":{"input_tokens":100,"output_tokens":25}}}' \
        > "$HOME/.claude/projects/nix-smoke/session.jsonl"
      tokentopper json > report.json
      jq -e '
        .schema == "tokentopper-summary/1" and
        .tool.name == "tokentopper" and
        .tool.version == "${finalAttrs.version}" and
        (has("machine") | not)
      ' report.json
      touch "$out"
    '';
  };

  meta = {
    description = "Professional AI Usage Index for Claude Code, Codex, and OpenCode";
    homepage = "https://openfactoryai.com/tools/tokentopper/";
    changelog = "https://github.com/Kalmantic/tokentopper/releases/tag/tokentopper-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juskashi ];
    mainProgram = "tokentopper";
    platforms = lib.platforms.unix;
  };
})
