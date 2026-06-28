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
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZXjOuf8xjKtFnxzrb4mU6TBae75Nyl6zGllT9orbNMY=";
  };

  cargoHash = "sha256-78lTRHIy1VYJP3dxljfrsMh1MXT7dyVw2yxHNrGJJk0=";

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
