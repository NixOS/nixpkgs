{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  testers,
  updatecli,
}:

buildGoModule rec {
  pname = "updatecli";
  version = "0.95.1";

  src = fetchFromGitHub {
    owner = "updatecli";
    repo = "updatecli";
    rev = "v${version}";
    hash = "sha256-ShiknNLbBAyNcXK3k+yhnqilkAovuwFaY3iWa5Plsbo=";
  };

  vendorHash = "sha256-iuE8rphRnedYg0G2kG1WGXL1rJ/k54Oc4fp2ExP2Rro=";

  # tests require network access
  doCheck = false;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/updatecli/updatecli/pkg/core/version.BuildTime=unknown"
    ''-X "github.com/updatecli/updatecli/pkg/core/version.GoVersion=go version go${lib.getVersion go}"''
    "-X github.com/updatecli/updatecli/pkg/core/version.Version=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = updatecli;
      command = "updatecli version";
    };
  };

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
    description = "Declarative Dependency Management tool";
    longDescription = ''
      Updatecli is a command-line tool used to define and apply update strategies.
    '';
    homepage = "https://www.updatecli.io";
    changelog = "https://github.com/updatecli/updatecli/releases/tag/${src.rev}";
    license = licenses.asl20;
    mainProgram = "updatecli";
    maintainers = with maintainers; [ croissong ];
  };
}
