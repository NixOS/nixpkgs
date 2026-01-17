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
  makeBinaryWrapper,
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
            "invalid/table/append-with-dotted-keys-04"
            "invalid/table/super-twice"
            "valid/array/array"
            "valid/comment/everywhere"
            "valid/comment/nonascii"
            "valid/datetime/datetime"
            "valid/datetime/edge"
            "valid/datetime/leap-year"
            "valid/datetime/local"
            "valid/datetime/local-date"
            "valid/datetime/local-time"
            "valid/datetime/milliseconds"
            "valid/datetime/timezone"
            "valid/example"
            "valid/key/like-date"
            "valid/key/numeric-04"
            "valid/key/quoted-unicode"
            "valid/spec-1.0.0/local-date-0"
            "valid/spec-1.0.0/local-date-time-0"
            "valid/spec-1.0.0/local-time-0"
            "valid/spec-1.0.0/offset-date-time-0"
            "valid/spec-1.0.0/offset-date-time-1"
            "valid/spec-1.0.0/table-7"
            "valid/spec-example-1"
            "valid/spec-example-1-compact"
            "valid/string/quoted-unicode"
          ];
        in
        runCommand "taplo-toml-test"
          {
            nativeBuildInputs = [
              makeBinaryWrapper
              toml-test
            ];
          }
          ''
            makeWrapper ${lib.getExe finalAttrs.finalPackage} ./taplo-toml-test --add-flag toml-test
            toml-test test -decoder=./taplo-toml-test -toml=1.0 ${
              lib.concatMapStringsSep " " (a: "-skip ${a}") skips
            }
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
