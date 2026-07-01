{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  nodejs,
  usage,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usage";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j5aS+zjGyQhUNv59GACMwZuSpN/jBzZNbe2VoBfxF/Y=";
  };

  cargoHash = "sha256-xAENsXf/VW4nkRiXIA9DppD/PyjoU3fxu4UNPYGYTho=";

  postPatch = ''
    substituteInPlace ./examples/*.sh \
      --replace-fail '/usr/bin/env -S usage' "$(pwd)/target/${stdenv.targetPlatform.rust.rustcTargetSpec}/release/usage"
  '';

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    # for some tests
    nodejs
  ];

  checkFlags = [
    # has --include-bash-completion-lib so requires external lib downloaded on runtime
    "--skip=test_bash_completion_init_integration"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
