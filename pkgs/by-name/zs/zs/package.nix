{
  lib,
  stdenv,
  fetchFromGitea,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "zs";
  version = "0.4.5";

  src = fetchFromGitea {
    domain = "git.mills.io";
    owner = "prologic";
    repo = "zs";
    rev = finalAttrs.version;
    hash = "sha256-NYnr0s730u4ICppPVZAAHB753XVooZtSSKIAp+z98Gw=";
  };

  vendorHash = "sha256-21UukhXVVj1AO+HlTlEpHkf5zLHA6dapjrOriVQd1jM=";

  ldflags = [
    "-w"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.Commit=${finalAttrs.src.rev}"
    "-X=main.Build=1970-01-01T00:00:00+00:00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zs \
      --bash <($out/bin/zs completion bash) \
      --fish <($out/bin/zs completion fish) \
      --zsh <($out/bin/zs completion zsh)
  '';

  meta = {
    description = "Extremely minimal static site generator written in Go";
    homepage = "https://git.mills.io/prologic/zs";
    changelog = "https://git.mills.io/prologic/zs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wariuccio ];
    mainProgram = "zs";
  };
})
