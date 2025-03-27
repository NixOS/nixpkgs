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
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-No/BDBW/NRnF81UOuAMrAs4cXEdzEAxnmkn67mReUcM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W/CuXzwacarxgVv12TMVfo7Fr9qKJ7aZIO8xf4SygNA=";

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
