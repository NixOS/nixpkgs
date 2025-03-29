{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  nix-update-script,
}:

buildGoModule rec {
  pname = "uplosi";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "edgelesssys";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5I916T70sH4UAq5EGRjR7lnRBbPqMJIxaXwUCJQ4DcM=";
  };

  vendorHash = "sha256-2lJmPNLpI1ksFb0EtcjPjyTy7eX1DKeX0F80k9FtGno=";

  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd uplosi \
      --bash <($out/bin/uplosi completion bash) \
      --fish <($out/bin/uplosi completion fish) \
      --zsh <($out/bin/uplosi completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Upload OS images to cloud provider";
    homepage = "https://github.com/edgelesssys/uplosi";
    changelog = "https://github.com/edgelesssys/uplosi/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "uplosi";
    maintainers = with lib.maintainers; [
      katexochen
      malt3
    ];
    platforms = lib.platforms.unix;
  };
}
