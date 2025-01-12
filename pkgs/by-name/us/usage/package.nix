{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  nix-update-script,
  usage,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-+Wt/ZOwj9LHgt0EOFF554TGf2tZyuRoXAPpCebPZfNY=";
  };

  cargoHash = "sha256-w8GWvMjC6Plho+zw542Q00hU/KZMdyyoP/rGAg72h1s=";

  postPatch = ''
    substituteInPlace ./examples/mounted.sh \
      --replace-fail '/usr/bin/env -S usage' "$(pwd)/target/${stdenv.targetPlatform.rust.rustcTargetSpec}/release/usage"
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
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
    changelog = "https://github.com/jdx/usage/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "usage";
  };
}
