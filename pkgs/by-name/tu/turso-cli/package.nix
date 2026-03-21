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
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3u5yc49v0vwNKaI5GcE+rDEoscbQqpnaN11Bax0SEtE=";
  };

  vendorHash = "sha256-Cb4/KA9jfI/pNHbJqLWtm9oEXfMHGBS46J9o3lL4/Tk=";

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
