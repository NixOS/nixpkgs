{
  lib,
  stdenv,
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
  version = "0.108.0";

  src = fetchFromGitHub {
    owner = "updatecli";
    repo = "updatecli";
    rev = "v${version}";
    hash = "sha256-JFv40wtfjNMQrjmku7iVwJ0MquaHPyiRaN9Ti5tCUwI=";
  };

  vendorHash = "sha256-9tA55vTI+UARfR1hxmdb9iuByPeKfFLLwAbwoCG0dsc=";

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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
