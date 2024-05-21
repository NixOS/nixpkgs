{ lib
, go
, buildGoModule
, fetchFromGitHub
, nix-update-script
, installShellFiles
}:

buildGoModule rec {
  pname = "updatecli";
  version = "0.77.0";

  src = fetchFromGitHub {
    owner = "updatecli";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sBkTdr4/DqNrCxtaM1tVTx+rQ1dvJ1KwlFvAJHIZCuw=";
  };

  vendorHash = "sha256-xY2nNDMnUyV2sOMOJfSHbXaEU/gOKfZkA77d0lhDlgg=";

  # tests require network access
  doCheck = false;

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/updatecli/updatecli/pkg/core/version.BuildTime=unknown"
    ''-X "github.com/updatecli/updatecli/pkg/core/version.GoVersion=go version go${lib.getVersion go}"''
    "-X github.com/updatecli/updatecli/pkg/core/version.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd updatecli \
      --bash <($out/bin/updatecli completion bash) \
      --fish <($out/bin/updatecli completion fish) \
      --zsh <($out/bin/updatecli completion zsh)

    $out/bin/updatecli man > updatecli.1
    installManPage updatecli.1
  '';

  meta = with lib; {
    description = "A Declarative Dependency Management tool";
    longDescription = ''
      Updatecli is a command-line tool used to define and apply update strategies.
    '';
    homepage = "https://www.updatecli.io";
    changelog = "https://github.com/updatecli/updatecli/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "updatecli";
    maintainers = with maintainers; [ croissong ];
  };
}
