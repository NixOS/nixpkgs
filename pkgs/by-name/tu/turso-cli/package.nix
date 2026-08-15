{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "turso-cli";
  version = "1.0.31";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B1sm1RBJneSoNYUrXTXMzB7n+UAmn6RlFtV1BZpOdZM=";
  };

  vendorHash = "sha256-4OIJVL3N2mWOw7ZDP4xFCxa9zmUTPCA8N79TVoi1lys=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X github.com/tursodatabase/turso-cli/internal/cmd.version=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd turso \
      --bash <($out/bin/turso completion bash) \
      --fish <($out/bin/turso completion fish) \
      --zsh <($out/bin/turso completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
