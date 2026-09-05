{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  nodejs,
  bashInteractive,
  usage,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usage";
  version = "6.6.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OQCIQqR8tO10w1WTi6rPCdBN5o9bZetmwGojU3p4o4I=";
  };

  cargoHash = "sha256-dZo75rg3kh4R7D79A1JOYnq0s8iWzf1bJffm3oK7I2A=";

  # Upstream's releases ship only the `usage` binary.
  cargoBuildFlags = [
    "-p"
    "usage-cli"
  ];
  cargoTestFlags = [
    "-p"
    "usage-cli"
  ];

  postPatch = ''
    substituteInPlace ./examples/*.sh \
      --replace-fail '/usr/bin/env -S usage' "$(pwd)/target/${stdenv.targetPlatform.rust.rustcTargetSpec}/release/usage"
  '';

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    # for some tests
    nodejs
    bashInteractive
  ];

  postInstall = ''
    installManPage ./cli/assets/usage.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd usage \
      --bash <($out/bin/usage --completions bash) \
      --fish <($out/bin/usage --completions fish) \
      --zsh <($out/bin/usage --completions zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = usage; };
  };

  meta = {
    homepage = "https://usage.jdx.dev";
    description = "Specification for CLIs";
    changelog = "https://github.com/jdx/usage/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "usage";
  };
})
