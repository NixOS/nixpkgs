{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:
buildGoModule rec {
  pname = "uplosi";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "edgelesssys";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AtsFZ92WkVkH8fd0Xa0D6/PR84/dtOH6gpM4mtn32Hk=";
  };

  vendorHash = "sha256-o7PPgW3JL47G6Na5n9h3RasRMfU25FD1U/wCMaydRmc=";

  CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd uplosi \
      --bash <($out/bin/uplosi completion bash) \
      --fish <($out/bin/uplosi completion fish) \
      --zsh <($out/bin/uplosi completion zsh)
  '';

  meta = with lib; {
    description = "Upload OS images to cloud provider";
    homepage = "https://github.com/edgelesssys/uplosi";
    changelog = "https://github.com/edgelesssys/uplosi/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "uplosi";
    maintainers = with maintainers; [ katexochen malt3 ];
    platforms = platforms.unix;
  };
}
