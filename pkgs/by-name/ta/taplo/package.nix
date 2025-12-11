{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  installShellFiles,
  versionCheckHook,

  # passthru dependencies
  nix-update-script,
  runCommand,
  toml-test,

  # Optional feature
  withLsp ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taplo";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "tamasfe";
    repo = "taplo";
    tag = "release-taplo-cli-${finalAttrs.version}";
    hash = "sha256-FW8OQ5TRUuQK8M2NDmp4c6p22jsHodxKqzOMrcdiqXU=";
  };

  cargoPatches = [
    # Update reqwest to fix darwin sandboxing issues
    # See also: https://github.com/tamasfe/taplo/pull/669
    ./update-reqwest.patch
  ];

  cargoHash = "sha256-FMpGo+kRcNgDj4qwYvdQKGwGazUKKMIVq0HCYMrTql0=";

  buildAndTestSubdir = "crates/taplo-cli";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  buildFeatures = lib.optional withLsp "lsp";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd taplo \
      --bash <($out/bin/taplo completions bash) \
      --fish <($out/bin/taplo completions fish) \
      --zsh <($out/bin/taplo completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      toml-test =
        let
          # Unfortunately, taplo does not yet pass all toml-test v1.6.0 tests.
          # Some of the failures are reported issues, others may not be.
          # https://github.com/tamasfe/taplo/issues/486
          skips = [
            "valid/comment/nonascii"
            "valid/datetime/edge"
            "valid/key/quoted-unicode"
            "valid/string/quoted-unicode"
            "invalid/control/multi-cr"
            "invalid/control/rawmulti-cr"
            "invalid/table/super-twice"
          ];
        in
        runCommand "taplo-toml-test"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              toml-test
            ];
          }
          ''
            toml-test taplo ${lib.concatMapStringsSep " " (a: "-skip ${a}") skips} -- toml-test
            touch "$out"
          '';
    };
  };

  meta = {
    description = "TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      yzx9
    ];
    mainProgram = "taplo";
  };
})
