{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "turso-cli";
  version = "1.0.27";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WTelkOo3b9y4ZpDscSsVITqzTVLGCGH9H1PkvkgFLY0=";
  };

  vendorHash = "sha256-4OIJVL3N2mWOw7ZDP4xFCxa9zmUTPCA8N79TVoi1lys=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X github.com/tursodatabase/turso-cli/internal/cmd.version=v${finalAttrs.version}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd turso \
      --bash <($out/bin/turso completion bash) \
      --fish <($out/bin/turso completion fish) \
      --zsh <($out/bin/turso completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Turso";
    homepage = "https://turso.tech";
    mainProgram = "turso";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zestsystem
      kashw2
      fryuni
    ];
  };
})
