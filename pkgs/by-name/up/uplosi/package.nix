{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  nix-update-script,
}:

buildGoModule rec {
  pname = "uplosi";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "edgelesssys";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i/RVCoeQLeOaPaEtJS/l+42CVohMucA6cBBt0mdJ4uE=";
  };

  vendorHash = "sha256-f8Yz99qlN0S0Ybewifc0VQanYXKinb1togBkUwDPSvw=";

  CGO_ENABLED = "0";
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
