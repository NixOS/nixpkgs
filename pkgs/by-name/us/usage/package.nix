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
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E8RKAyZ/1cr7FE3iGnTPFGBfoHKCs+kCrqNvCl7cogw=";
  };

  cargoHash = "sha256-KX9jNLDq4N0EyWRSxF12LF3PJraAAjRldpRdFQJBChQ=";

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
